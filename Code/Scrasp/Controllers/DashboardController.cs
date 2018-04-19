using Scrasp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using System.Net;

namespace Scrasp.Controllers
{
    public class DashboardController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: Dashboard
        public ActionResult Index()
        {
            if (User.Identity.IsAuthenticated)
            {
                DashboardViewModel model = new DashboardViewModel();

                List<ScraspUser> users = db.ScraspUsers.ToList();
                List<Team> teams = db.Teams.ToList();
                List<Job> jobs = db.Jobs.ToList();

                // Get the connected User and all his projects / jobs
                ScraspUser connectedUser = users.Find(u => u.AspNetUsers_id == User.Identity.GetUserId());
                List<Project> userProjects = new List<Project>();
                List<Job> userJobs = new List<Job>();

                foreach (Team team in teams)
                {
                    if (team.ScraspUsers_id == connectedUser.id)
                    {
                        userProjects.Add(db.Projects.Find(team.Projects_id));
                    }
                }
                foreach (Job job in jobs)
                {
                    if (job.ScraspUsers_id == connectedUser.id)
                    {
                        if (job.JobState.hideInDashboard != 1)
                        {
                            userJobs.Add(job);
                        }
                    }
                }

                model.userProjects = userProjects;
                model.userJobs = userJobs;
                return View(model);
            }
            // No authorisation -> 403 forbidden
            else
            {
                return new HttpStatusCodeResult(HttpStatusCode.Forbidden);
            }
    
        }

        // POST: Dashboard/CloseJob
        [HttpPost]
        public ActionResult CloseJob(int? jobId)
        {
            if (User.Identity.IsAuthenticated)
            {   
                // bad post request (no jobId found)
                if (jobId == null)
                {
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
                }
                else
                {
                    Job job = db.Jobs.Find(jobId); // Job to be close

                    List<JobState> jobStates = db.JobStates.ToList();
                    JobState terminateState = jobStates.Find(Js => Js.stateName == "Terminé"); // Get the close JobState

                    // Close the job and save the db
                    job.JobState = terminateState;
                    db.SaveChanges();
                }

                return RedirectToAction("Index", "Dashboard");
            }
            // No authorisation -> 403 forbidden
            else
            {
                return new HttpStatusCodeResult(HttpStatusCode.Forbidden);
            }

        }

    }
}