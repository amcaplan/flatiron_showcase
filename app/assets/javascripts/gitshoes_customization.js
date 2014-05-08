var intervalTracker = {};

var customizeGitShoes = function(){
  if (jQuery("#feedback-container")[0]) {
    // Move gitShoes to the left side
    jQuery("#feedback-container").css('right', 'none').css('left','5px')
    jQuery("#gitshoes-button").css('float', 'left');

    // Customize gitShoes text
    jQuery("label[for=issue_body").text("Problems with the site? Suggestions? Comments? Let us know!");
    jQuery("#feedback-submit").attr('value', 'Submit!');

    // Make link to gitShoes website open in a new window
    jQuery("#feedback-container a").attr('target', '_blank');

    // Let users see it now!
    jQuery("#feedback-container").css('display', 'block');
    
    // Don't repeat!
    clearInterval(intervalTracker.intervalID);
  }
};

jQuery(document).ready(function(){
  jQuery("#main-wrapper").click(function(){
    jQuery("#gitshoes-form").slideUp();
  })
  intervalTracker.intervalID = setInterval('customizeGitShoes()', 500);
});