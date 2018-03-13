using Scrasp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Scrasp.Controllers {
    public class HomeController : Controller {

        private scraspEntities db = new scraspEntities();

        public ActionResult Index() {
            var projects = db.Projects.ToList();
            ViewBag.projects = projects;
            return View();
        }

        public ActionResult About() {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact() {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}