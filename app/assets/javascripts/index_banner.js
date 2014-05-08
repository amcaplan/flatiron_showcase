var tpj = jQuery;
tpj.noConflict();
tpj(document).ready(function () {
    // Revolution Slider
    if (tpj.fn.cssOriginal != undefined)
        tpj.fn.css = tpj.fn.cssOriginal;
    tpj('.fullwidthbanner').revolution({
        delay: 15000,
        startwidth: 1200,
        startheight: 400,

        onHoverStop: "on",

        thumbWidth: 100,
        thumbHeight: 50,
        thumbAmount: 3,

        hideThumbs: 0,

        navigationType: "none",
        navigationArrows: "solo",
        navigationStyle: "round",
        navigationHAlign: "left",
        navigationVAlign: "bottom",
        navigationHOffset: 30,
        navigationVOffset: 30,

        soloArrowLeftHalign: "left",
        soloArrowLeftValign: "center",
        soloArrowLeftHOffset: 20,
        soloArrowLeftVOffset: 0,

        soloArrowRightHalign: "right",
        soloArrowRightValign: "center",
        soloArrowRightHOffset: 20,
        soloArrowRightVOffset: 0,

        stopAtSlide: -1,
        stopAfterLoops: -1,
        hideCaptionAtLimit: 0,
        hideAllCaptionAtLilmit: 0,
        hideSliderAtLimit: 0,

        fullWidth: "on",
        fullScreen: "off",
        fullScreenOffsetContainer: "#topheader-to-offset",

        shadow: 0
    });
    // PrettyPhoto
    tpj("a[rel^='prettyPhoto']").prettyPhoto({
        theme: 'light_square',
        social_tools: false
    });
    // jQuery UItoTop
    tpj().UItoTop({ easingType: 'easeOutQuart' });
});  