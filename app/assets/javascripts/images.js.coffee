currentProjectID = $(location).attr('href').match(/\/\d+\//)[0].slice(1,-1)

selectivelyActivateUploadButton = ->
  $('#new-project-image').change ->
    $button = $('#project-image-upload-button')
    if $(@).val()
      $button.removeClass('disabled')
    else
      $button.addClass('disabled')

bindImageAdminLinks = ->
  $('.image-container').on 'click', '.set-as-primary', ->
    imageID = $(@).closest('.image-container').data("image-num")    
    $.post "/projects/#{currentProjectID}/set-primary-image/#{imageID}", (response) =>
      $('#primary-image-section').html(response)
      $('.set-as-primary').removeClass('disabled')
      $(@).addClass('disabled')

  $('.image-container').on 'click', '.delete-image', ->
    $affectedImage = $(@).closest('.image-container')
    imageID = $affectedImage.data("image-num")
    $.post "/projects/#{currentProjectID}/images/#{imageID}/destroy", (response) =>
      $('#primary-image-section').html(response)
      $affectedImage.remove()
      newPrimaryImageID = $("#primary-image").data("image-num")
      $newBox = $(".image-container[data-image-num=#{newPrimaryImageID}]")
      $newBox.find('.set-as-primary').addClass('disabled')
      if $('.image-container').length < 2
        $('.delete-image').addClass('disabled')


bindRetakeScreenshotButton = ->
  $("#take-screenshot").click ->
    $(@).addClass("disabled")
    $.post "/projects/#{currentProjectID}/new-screenshot", (response) =>
      $('#current-images').html(response)
      $(@).removeClass("disabled")
      bindImageAdminLinks()


$(document).ready ->
    selectivelyActivateUploadButton()
    bindImageAdminLinks()
    bindRetakeScreenshotButton()