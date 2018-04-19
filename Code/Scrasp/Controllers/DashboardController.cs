using Scrasp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using System.Security.Claims;
using System.Net;
using System.Data.Entity;

namespace Scrasp.Controllers
{
    public class DashboardController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: Dashboard
        public ActionResult Index()
        {
            DashboardViewModel vm = new DashboardViewModel();

            string userId = User.Identity.GetUserId<string>();
            ScraspUser currentUser = db.ScraspUsers.Where(u => u.AspNetUsers_id == userId).First();

            // Get the list of jobs
            List<Job> jobs = db.Jobs
                .Where(t => t.JobState.hideInDashboard != 1)
                .Where(t => t.ScraspUsers_id == currentUser.id)
                .ToList();
            vm.jobs = jobs;
            
            // Get the list projects
            List<Project> projects = currentUser.Teams
                .Select( t=> t.Project) //get only the projects of the current usrs team
                .Distinct()// remove doubles
                .ToList();

            vm.projects = projects;
            return View(vm);
        }

        // GET: /Dashboard/Close?jobId=1
        // jobId here represents the job id to close
        public ActionResult Close(int? jobId)
        {
            if(jobId == null)
            {
                return new HttpStatusCodeResult(statusCode: HttpStatusCode.BadRequest);
            }
            Job job = db.Jobs.Find(jobId);
            if(job.JobState.allowClosure != 1) //check if we can close the job
            {
                return new HttpStatusCodeResult(statusCode: HttpStatusCode.Forbidden);
            }
            // Don't know which is best?
            job.JobState = db.JobStates.Where(js => js.stateName == "Terminé").First();
            // or 
            // job.JobState = db.JobStates.Find(4);
            
            job.endDate = DateTime.Now;
            db.Entry(job).State = EntityState.Modified;
            db.SaveChanges();
            return Redirect("/Dashboard");
        }
    }
}