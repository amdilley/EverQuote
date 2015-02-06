require 'net/http'

class ReadNoteController < ApplicationController
  QUOTE_BOOK_GUID = 'c00de376-55ed-46d1-b914-d13ff30f34e3'

  def quote_from_xml xml_string
    xml_doc = Nokogiri::XML xml_string

    quotes = xml_doc.xpath('//li/text()')
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
    @note = get_random_note

    uri = URI('https://api.pushbullet.com/v2/pushes')
    req = Net::HTTP::Post.new(uri)

    req['Authorization'] = "Bearer #{PUSH_BULLET_TOKEN}"
    req.set_form_data(
        'channel_tag' => 'everquote',
        'type'        => 'note',
        'title'       => @note[:title],
        'body'        => @note[:content]
      )

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    res = http.start do |h|
      h.request(req)
    end

    render :json => nil, :status => :ok
  end
end