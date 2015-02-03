class ReadNoteController < ApplicationController
  QUOTE_BOOK_GUID = 'c00de376-55ed-46d1-b914-d13ff30f34e3'

  def quote_from_xml xml_string
    xml_doc = Nokogiri::XML xml_string

    quotes = xml_doc.xpath('//li')
    index  = rand(quotes.length)
    quote  = quotes[index].to_s
  end

  def get_random_note
    q_filter = Evernote::EDAM::NoteStore::NoteFilter.new :notebookGuid => QUOTE_BOOK_GUID
    q_spec   = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new 
    quotes   = note_store.findNotesMetadata(auth_token, q_filter, 0, 1000, q_spec).notes

    notes_array = []

    quotes.each do |note|
      guid              = note.guid
      note_with_content = note_store.getNote(auth_token, guid, true, false, false, false)
      content           = quote_from_xml note_with_content.content

      notes_array << { :title => note_with_content.title, :content => content }
    end

    notes_array.sample
  end

  def push_note
    note    = get_random_note

    render :json => note

  end
end