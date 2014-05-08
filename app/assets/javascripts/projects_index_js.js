$(document).ready(function () {
    // PrettyPhoto
    $("a[rel^='prettyPhoto']").prettyPhoto({
        theme: 'light_square',
        social_tools: false
    });
});

// Isotope Portfolio
var $container = $('#isotope-portfolio-container');
var $filter = $('.portfolio-filter');
$(window).load(function () {
    // Initialize Isotope
    $container.isotope({
        itemSelector: '.portfolio-item-wrapper'
    });
    $('.portfolio-filter a').click(function () {
        var selector = $(this).attr('data-filter');
        $container.isotope({ filter: selector });
        return false;
    });
    $filter.find('a').click(function () {
        var selector = $(this).attr('data-filter');
        $filter.find('a').parent().removeClass('active');
        $(this).parent().addClass('active');
    });
});
$(window).smartresize(function () {
    $container.isotope('reLayout');
});

$(document).ready(function () {
    $().UItoTop({ easingType: 'easeOutQuart' });
});