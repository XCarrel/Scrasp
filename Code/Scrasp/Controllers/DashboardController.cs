using Scrasp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using System.Web.Security;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace Scrasp.Controllers
{
    public class DashboardController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: Dashboard
        public ActionResult Index()
        {
            DashboardViewModels model = new DashboardViewModels();

            model.projects = db.Projects.Include(p => p.Teams).ToList();
            model.jobs = db.Jobs.Include(j => j.JobState).ToList();
            model.teams = db.Teams.ToList();

            // Get the logged user 
            // !! THROW ERROR IF ERROR NOT LOGGED
            ApplicationDbContext context = new ApplicationDbContext();
            var UserManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(context));
            ApplicationUser currentUser = UserManager.FindById(User.Identity.GetUserId());
            string Username = currentUser.UserName.Split('@').First();

            model.loggedUser = db.ScraspUsers.Where(s => s.username.Equals(Username)).First();

            return View(model);
        }
    }
}