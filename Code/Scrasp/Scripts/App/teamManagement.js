$(document).ready(function () {

    // Handle requests to add/remove a user to/from a project through the API
    $(".userteam").dblclick(function (event) {
        $.ajax({
            url: "/API/ToggleUserTeam",
            data: {
                projectId: $(this).data("project"),
                userId: $(this).data("user")
            },
            error: function () {
                console.log("API Error");
            },
            success: function (newstate) {
                switch (newstate)
                {
                    case "0": // removed ok
                        $(event.target).removeClass("isinteam");
                        break;
                    case "1": // added ok
                        $(event.target).addClass("isinteam");
                        break;
                    case "2": // remove denied
                        alert("Désolé, mais y'a encore du job...");
                        $(event.target).addClass("isinteam");
                        break;
                }
            },
            type: "POST"
        });
    });
});
