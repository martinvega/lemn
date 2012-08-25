jQuery ($)->
  $(document).on 'focus keydown click', 'input[data-date-picker]', ->
    year = $(this).data('year')
    $(this).datepicker
      showOn: 'both'
      dateFormat: 'yy-mm-dd'
      changeMonth: true if year?
      changeYear: true if year?
      yearRange: "c-90:c" if year?
      onSelect: -> $(this).datepicker('hide')
    .removeAttr('data-date-picker').focus()