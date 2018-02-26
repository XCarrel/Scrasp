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
    public class StoriesController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: Stories
        public ActionResult Index()
        {
            var stories = db.Stories.Include(s => s.Project).Include(s => s.Sprint).Include(s => s.StoryState).Include(s => s.StoryType);
            return View(stories.ToList());
        }

        // GET: Stories/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Story story = db.Stories.Find(id);
            if (story == null)
            {
                return HttpNotFound();
            }
            return View(story);
        }

        // GET: Stories/Create
        public ActionResult Create()
        {
            ViewBag.Projects_id = new SelectList(db.Projects, "id", "title");
            ViewBag.Sprints_id = new SelectList(db.Sprints, "id", "sprintDescription");
            ViewBag.StoryStates_id = new SelectList(db.StoryStates, "id", "stateName");
            ViewBag.StoryTypes_id = new SelectList(db.StoryTypes, "id", "typeName");
            return View();
        }

        // POST: Stories/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,shortName,actor,storyDescription,StoryTypes_id,StoryStates_id,Sprints_id,Projects_id,points")] Story story)
        {
            if (ModelState.IsValid)
            {
                db.Stories.Add(story);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.Projects_id = new SelectList(db.Projects, "id", "title", story.Projects_id);
            ViewBag.Sprints_id = new SelectList(db.Sprints, "id", "sprintDescription", story.Sprints_id);
            ViewBag.StoryStates_id = new SelectList(db.StoryStates, "id", "stateName", story.StoryStates_id);
            ViewBag.StoryTypes_id = new SelectList(db.StoryTypes, "id", "typeName", story.StoryTypes_id);
            return View(story);
        }

        // GET: Stories/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Story story = db.Stories.Find(id);
            if (story == null)
            {
                return HttpNotFound();
            }
            ViewBag.Projects_id = new SelectList(db.Projects, "id", "title", story.Projects_id);
            ViewBag.Sprints_id = new SelectList(db.Sprints, "id", "sprintDescription", story.Sprints_id);
            ViewBag.StoryStates_id = new SelectList(db.StoryStates, "id", "stateName", story.StoryStates_id);
            ViewBag.StoryTypes_id = new SelectList(db.StoryTypes, "id", "typeName", story.StoryTypes_id);
            return View(story);
        }

        // POST: Stories/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,shortName,actor,storyDescription,StoryTypes_id,StoryStates_id,Sprints_id,Projects_id,points")] Story story)
        {
            if (ModelState.IsValid)
            {
                db.Entry(story).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.Projects_id = new SelectList(db.Projects, "id", "title", story.Projects_id);
            ViewBag.Sprints_id = new SelectList(db.Sprints, "id", "sprintDescription", story.Sprints_id);
            ViewBag.StoryStates_id = new SelectList(db.StoryStates, "id", "stateName", story.StoryStates_id);
            ViewBag.StoryTypes_id = new SelectList(db.StoryTypes, "id", "typeName", story.StoryTypes_id);
            return View(story);
        }

        // GET: Stories/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Story story = db.Stories.Find(id);
            if (story == null)
            {
                return HttpNotFound();
            }
            return View(story);
        }

        // POST: Stories/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Story story = db.Stories.Find(id);
            db.Stories.Remove(story);
            db.SaveChanges();
            return RedirectToAction("Index");
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
