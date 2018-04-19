using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Scrasp.Models;

namespace Scrasp.Controllers
{
    public class JobsController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: Jobs
        public ActionResult Index()
        {
            var jobs = db.Jobs.Include(j => j.JobState).Include(j => j.ScraspUser).Include(j => j.Story);
            return View(jobs.ToList());
        }

        // GET: Jobs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Job job = db.Jobs.Find(id);
            if (job == null)
            {
                return HttpNotFound();
            }
            return View(job);
        }

        // GET: Jobs/Create
        public ActionResult Create()
        {
            ViewBag.JobStates_id = new SelectList(db.JobStates, "id", "stateName");
            ViewBag.ScraspUsers_id = new SelectList(db.ScraspUsers, "id", "AspNetUsers_id");
            ViewBag.Stories_id = new SelectList(db.Stories, "id", "shortName");
            return View();
        }

        // POST: Jobs/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,jobDescription,startDate,endDate,JobStates_id,Stories_id,ScraspUsers_id")] Job job)
        {
            if (ModelState.IsValid)
            {
                db.Jobs.Add(job);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.JobStates_id = new SelectList(db.JobStates, "id", "stateName", job.JobStates_id);
            ViewBag.ScraspUsers_id = new SelectList(db.ScraspUsers, "id", "AspNetUsers_id", job.ScraspUsers_id);
            ViewBag.Stories_id = new SelectList(db.Stories, "id", "shortName", job.Stories_id);
            return View(job);
        }

        // GET: Jobs/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Job job = db.Jobs.Find(id);
            if (job == null)
            {
                return HttpNotFound();
            }
            ViewBag.JobStates_id = new SelectList(db.JobStates, "id", "stateName", job.JobStates_id);
            ViewBag.ScraspUsers_id = new SelectList(db.ScraspUsers, "id", "AspNetUsers_id", job.ScraspUsers_id);
            ViewBag.Stories_id = new SelectList(db.Stories, "id", "shortName", job.Stories_id);
            return View(job);
        }

        // POST: Jobs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,jobDescription,startDate,endDate,JobStates_id,Stories_id,ScraspUsers_id")] Job job)
        {
            if (ModelState.IsValid)
            {
                db.Entry(job).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.JobStates_id = new SelectList(db.JobStates, "id", "stateName", job.JobStates_id);
            ViewBag.ScraspUsers_id = new SelectList(db.ScraspUsers, "id", "AspNetUsers_id", job.ScraspUsers_id);
            ViewBag.Stories_id = new SelectList(db.Stories, "id", "shortName", job.Stories_id);
            return View(job);
        }

        // GET: Jobs/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Job job = db.Jobs.Find(id);
            if (job == null)
            {
                return HttpNotFound();
            }
            return View(job);
        }

        // POST: Jobs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Job job = db.Jobs.Find(id);
            db.Jobs.Remove(job);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        public ActionResult Close(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            // find the job
            Job job = db.Jobs.SingleOrDefault(j => j.id == id);
            if (job == null)
            {
                return HttpNotFound();
            }

            // check if the job can be closed
            if (job.JobState.allowClosure == 1)
            {
                // set job to "terminé"
                job.JobStates_id = 4;
                db.SaveChanges();
            }
            // return to dashboard
            return RedirectToAction("Index", "Dashboard");
        }


        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
