using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Scrasp.Models;

namespace Scrasp.Controllers {
    public class DashboardController : Controller {
        private scraspEntities db = new scraspEntities();

        // GET: Dashboard
        public ActionResult Index() {
            if (!Request.IsAuthenticated) {
                return Redirect("/");
            }

            string userId = User.Identity.GetUserId();
            ScraspUser user = db.ScraspUsers.First(u => u.AspNetUsers_id == userId);

            List<Project> projects = new List<Project>();
            List<Team> teams = user.Teams.ToList();
            foreach (Team team in teams) {
                projects.Add(team.Project);
            }

            DashboardViewModel model = new DashboardViewModel {
                Projects = projects,
                Jobs = user.Jobs.ToList()
            };

            return View(model);
        }
    }
}