using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Scrasp.Models;
using System.Data.Entity;

namespace Scrasp.Controllers
{
    public class DashboardController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: Dashboard
        public ActionResult Index()
        {
            // Prevent none connected users to access page
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("Account/Login");
            }

            // get authenticated username
            String authusername = System.Web.HttpContext.Current.User.Identity.Name.Split(new []{ '@' })[0];
            ScraspUser user = db.ScraspUsers.SingleOrDefault(u => u.username == authusername);

            List<Team> teams = db.Teams.Where(t => t.ScraspUsers_id == user.id).ToList();
            List<Project> userProjects = new List<Project>();

            foreach (Team team in teams)
            {
                // check that the project wasn't already added
                if (!userProjects.Contains(team.Project)) {
                    // add it
                    userProjects.Add(team.Project);
                }
            }

            DashboardViewModel dashboard = new DashboardViewModel
            {
                projects = userProjects,
                jobs = db.Jobs.Where(j => j.ScraspUsers_id == user.id).ToList()
            };

            return View(dashboard);
        }
    }
}
