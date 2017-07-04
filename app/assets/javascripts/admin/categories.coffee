# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
TableToggle =
  openInlineEditForm: (this_) ->
    id = $(this_).data(this.selectors.data)
    this.toggleRow(id)
    this.selectedRowId = id

  closeOpenedRow: (e) ->
    row = $(this.selectors.formId + this.selectedRowId)
    if !row.is(e.target) and row.find(e.target).length == 0
      this.toggleRow(this.selectedRowId)
      this.selectedRowId = null

  toggleRow: (id) ->
    $(this.selectors.rowId  + id).toggle()
    $(this.selectors.formId + id).toggle()

  selectedRowId: ''

  selectors:
    formId: "#edit_form_"
    rowId:  "#edit_row_"
    data: 'objectId'

$(document).on "turbolinks:load", ->
  $('.open_edit_form').click ->
    TableToggle.openInlineEditForm(this)

  $(document).mouseup (e) ->
    TableToggle.closeOpenedRow(e)

  element = $('.tree_element .visible_element')
  element.draggable()
  element.droppable(
    activeClass: 'activated'
    hoverClass: 'hovered'
  )
