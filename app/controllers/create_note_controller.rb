class CreateNoteController < ApplicationController
  def create_note
    new_note = Evernote::EDAM::Type::Note.new

    new_note.notebookGuid = params[:guid]
    new_note.title        = params[:title]
    new_note.content      = params[:content]

    note = note_store.createNote new_note
  end
end
