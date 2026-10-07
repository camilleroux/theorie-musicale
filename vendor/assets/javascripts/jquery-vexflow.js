// jquery.vexflow.js
// Copyright Ben Hughes
// https://github.com/rubiety/jquery-vexflow

(function($) {

  // When called on an element, will replace the contents of that element with 
  // a rendered-out staff using VexFlow and vexflow-json.
  // 
  // Accepts a vexflow-json data object.
  //
  // data - An object of vexflow-json data.
  //
  // Returns the jQuery object
  $.fn.vexflow = function(data, render_options) {
    return this.each(function() {
      $.vexflow(this, data, render_options);
    });
  };
  
  $.vexflow = function(element, data, render_options) {
    if (!Vex.Flow.JSON) {
      throw "Must require vexflow-json before using this.";
      return false;
    }

    // If we have a data-staff attribute and passed data is undefined, use it!
    if (!data && $(element).attr("data-staff")) { data = JSON.parse($(element).attr("data-staff")); }

    if (!render_options) { render_options = {}; }
    if (!render_options.width) { render_options.width = $(element).attr("data-width") || $(element).attr("width") || 600; }
    if (!render_options.height) { render_options.height = $(element).attr("data-height") || $(element).attr("height") || 110; }
    if (!render_options.scale) { render_options.scale = parseFloat($(element).attr("data-scale") || "1"); }
    if (!render_options.clef && $(element).attr("data-clef")) { render_options.clef = $(element).attr("data-clef").split(","); }

    // HiDPI: draw at 2x (or the screen density if higher) and display at the logical size,
    // so staves stay sharp on retina screens and when CSS scales them down
    var ratio = Math.max(2, Math.ceil(window.devicePixelRatio || 1));
    var width = parseInt(render_options.width, 10), height = parseInt(render_options.height, 10);
    var canvas_element = $("<canvas width='" + (width * ratio) + "' height='" + (height * ratio) + "'></canvas>");
    canvas_element.css({ width: width + "px", height: height + "px" });
    canvas_element.appendTo(element)

    return (new Vex.Flow.JSON(data)).render(canvas_element[0], $.extend({}, render_options, {
      width: width, height: height, scale: render_options.scale * ratio
    }));
  };

})(jQuery);
