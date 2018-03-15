$(document).ready(function () {

    $('.clickable').click(function () {
        window.location = $(this).data('url');
    });

    $('.show-edit').click(function () {
        $('.edit').show();
        $('.details').hide();
    });


    $('.cancel-edit').click(function () {
        $('.edit').hide();
        $('.details').show();
    });

});