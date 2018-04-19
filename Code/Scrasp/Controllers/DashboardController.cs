using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Scrasp.Models.ViewModels
{
    public class DashboardController : Controller
    {
        private scraspEntities db = new scraspEntities();
        // GET: Dashboard
        public ActionResult Index()
        {
            DashboardViewModel model = new DashboardViewModel();

            model.projects = db.Projects.ToList();
            model.users = db.ScraspUsers.ToList();
            model.teams = db.Teams.ToList();
            model.jobs = db.Jobs.ToList();
            model.states = db.JobStates.ToList();

            return View(model);
        }
    }
}