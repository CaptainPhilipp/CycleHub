tableToggle =
  selectedRowId: ''

  openInlineEditForm: (this_) ->
    id = $(this_).data(this.data)
    this.toggleRow(id)
    this.selectedRowId = id

  closeOpenedRow: (e) ->
    row = $(this.id.form + this.selectedRowId)
    if !row.is(e.target) and row.find(e.target).length == 0
      this.toggleRow(this.selectedRowId)
      this.selectedRowId = null

  toggleRow: (id) ->
    $(this.id.row  + id).toggle()
    $(this.id.form + id).toggle()

  id:
    form: "#edit_form_"
    row:  "#edit_row_"

  data: 'objectId'
