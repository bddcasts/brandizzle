$(document).ready(function() {
  $('form#dp input.txt').daterangepicker( {
    presetRanges: [
      { text: 'Today', dateStart: 'today', dateEnd: 'today' },
      { text: 'Yesterday', dateStart: 'yesterday', dateEnd: 'yesterday' },
      { text: 'Last 7 days', dateStart: 'today-7days', dateEnd: 'today' },
      { text: 'This month', dateStart: function(){ return Date.parse('today').moveToFirstDayOfMonth();  }, dateEnd: 'today' },
      { text: 'Last month', dateStart: function(){ return Date.parse('1 month ago').moveToFirstDayOfMonth();  }, dateEnd: function(){ return Date.parse('1 month ago').moveToLastDayOfMonth();  } },
      { text: 'Any time', dateStart: function(){ return Date.parse('-15years');  }, dateEnd: 'today' }
    ],
    
    presets: {
			specificDate: 'Specific Date', 
			dateRange: 'Date Range'
		},
		
		dateFormat: 'M d, yy',
		rangeSplitter: "to",
		
    onClose: function() {
/*      $('form#dp').submit();*/
    }
  });
});