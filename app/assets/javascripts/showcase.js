var revapi;

jQuery(document).ready(function() {

  revapi = jQuery('.tp-banner').revolution({
    
    delay:15000,
    startwidth:1170,
    startheight: 800,
    hideThumbs:10,
    fullWidth:"off",
    fullScreen:"on",
    fullScreenOffsetContainer: "",

    navigationType: "none",
    navigationArrows: "nexttobullet",
    navigationStyle: "round",
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

    shadow: "none"

  });

}); //ready