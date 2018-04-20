using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Scrasp.Models;

namespace Scrasp.Controllers
{
    public class DashboardController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: Dashboard
        public ActionResult Index()
        {
            DashboardViewModel myDashboard = new DashboardViewModel();

            // We need the Scrasp_users_id
            string username = User.Identity.Name;
            AspNetUser aspuser = db.AspNetUsers.Where(u => u.UserName.Equals(username)).First();
            int suid = aspuser.ScraspUsers.First().id;

            // My projects
            myDashboard.myProjects = new List<Project>();
            List<Team> teams = db.Teams.ToList();

            foreach (Project p in db.Projects)
                if (teams.Exists(t => t.Projects_id == p.id && t.ScraspUsers_id == suid))
                    myDashboard.myProjects.Add(p);

            myDashboard.myJobs = db.Jobs.Where(j => j.ScraspUser.id == suid && j.JobState.hideInDashboard != 1).ToList();

            return View(myDashboard);
        }
    }
}