$(document).ready(function () {
    // Handle requests to add/remove a user to/from a project through the API
    $(".close-job").click(function (event) {
        $.ajax({
            url: '/API/closeJob',
            data: {
                jobId: $(this).data("job"),
            },
            error: function () {
                console.log("API Error")
            },
            success: function (newstate) {
                
                switch (newstate) {
                    case "0": // removed ok
                        $(event.target).parent().parent().remove()
                        break
                    case "1": // remove denied
                        console.log("Vous devez être authentifié pour pouvoir executer cette requête")
                        break
                }
            },
            type: "PUT"
        })
    })
})