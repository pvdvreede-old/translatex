//= require ace/ace-bookmarklet
//= require ace/theme-textmate
//= require ace/mode-xml

$(document).ready(function() {
  var xslt_input = $("#translation_xslt");
  var editor;

  // ace functions
  var enableAce = function() {
    xslt_input.after("<div id='ace-xslt'></div>");
    editor = ace.edit("ace-xslt");
    xslt_input.hide();
    editor.getSession().setMode("ace/mode/xml");
    editor.getSession().setTabSize(2);
    editor.getSession().setUseSoftTabs(true);
    editor.getSession().setValue(xslt_input.val());
    editor.getSession().on('change', function(){
      xslt_input.val(editor.getSession().getValue());
    });
  };

  var disableAce = function() {
    //editor.getSession().unbind('change');
    $("#ace-xslt").remove();
    xslt_input.show();
  };

  // enable the ace editor
  enableAce();

  // add checkbox to disable it
  xslt_input.before(
    "<input id='ace-enabler' type='checkbox' checked />Enable ACE"
  );

  $('#ace-enabler').on('change', function(e) {
    if (e.target.checked) {
      enableAce();
    } else {
      disableAce();
    }
  });
});