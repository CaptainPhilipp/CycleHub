# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$selectedRowId = null

TableToggle =
  openInlineEditForm: (this_) ->
    id = $(this_).data(this.selectors.data)
    console.log("> open id " + id)  # DEBUG

    this.openRow(id)
    $selectedRowId = id

  closeOpenedRow: (e) ->
    return unless $selectedRowId
    row = $(this.selectors.formId + $selectedRowId)
    if !row.is(e.target) and row.find(e.target).length == 0
      console.log("< close id " + $selectedRowId) # DEBUG

      this.closeRow($selectedRowId)
      $selectedRowId = null

  openRow: (id) ->
    $(this.selectors.rowId  + id).hide()
    $(this.selectors.formId + id).show()

  closeRow: (id) ->
    $(this.selectors.formId + id).hide()
    $(this.selectors.rowId  + id).show()

  selectors:
    formId: "#edit_form_"
    rowId:  "#edit_row_"
    data: 'objectId'

$(document).on "turbolinks:load", ->
  $('.open_edit_form').click ->
    TableToggle.openInlineEditForm(this)

  $(document).mouseup (e) ->
    TableToggle.closeOpenedRow(e)

  $(document).bind "ajax:success", ->
    $('.open_edit_form').click ->
      TableToggle.openInlineEditForm(this)
