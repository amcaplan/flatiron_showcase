$(document).ready(function () {
    // PrettyPhoto
    $("a[rel^='prettyPhoto']").prettyPhoto({
        theme: 'light_square',
        social_tools: false
    });
});
// jQuery CarouFredSel
var caroufredsel = function () {
    $('#caroufredsel-portfolio-container').carouFredSel({
        responsive: true,
        scroll: 1,
        circular: false,
        infinite: false,
        items: {
            visible: {
                min: 1,
                max: 3
            },
            width: null,
            height: "variable"
        },
        prev: '#portfolio-prev',
        next: '#portfolio-next',
        auto: {
            play: true
        }
    });
};
$(window).load(function () {
    caroufredsel();
});
$(window).resize(function () {
    caroufredsel();
});     