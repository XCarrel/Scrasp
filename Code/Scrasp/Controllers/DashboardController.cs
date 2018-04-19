using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Scrasp.Models;
using System.Data.Entity;
using Microsoft.AspNet.Identity;

namespace Scrasp.Controllers
{
    public class DashboardController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: Dashboard
        public ActionResult Index()
        {
            var projects = db.Projects.ToList();
            //List<Team> teams = db.Teams.ToList();
            //Team membership = teams.Find(t => t.Projects_id == projectId && t.ScraspUsers_id == userId);

            // Get the list of jobs for the current user
            var currentUserId = User.Identity.GetUserId();
            var currentUser = db.ScraspUsers.Where(s => s.AspNetUsers_id == currentUserId).First();
            var currentUserJobs = currentUser.Jobs.ToList();

            var viewModel = new DashboardViewModel { Jobs = currentUserJobs };

            return View(viewModel);
        }
    }
}