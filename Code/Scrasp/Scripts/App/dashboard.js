
function closeJob(job_id) {
        // closing the given job
        console.log("closing the job...")
        $.ajax({
            url: "APi/GetJob/" + job_id,
            success: function () {
                var line = document.getElementById("job-" + job_id);
                line.style.display = "none";
            }
        })
        // TODO : API call does not work yet.
        // We still hide the line (delete these lines, and leave it in "success" callback)
        var line = document.getElementById("jobs-" + job_id);
        line.style.display = "none";
    }

