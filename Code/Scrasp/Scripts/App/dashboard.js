$(document).ready(function () {
    // Handle requests to add/remove a user to/from a project through the API
    $(".closeJob").on("click", function (event) {
        console.log("dd");
        $.ajax({
            url: '/API/closeJob',
            data: {
                jobId: $(this).data("jobid"),
            },
            error: function () {
                console.log("API Error");
            },
            success: function (response) {
                if (response === 1) {
                    $(event.target).parent().remove();
                }
            },
            type: "POST"
        });
    });
});