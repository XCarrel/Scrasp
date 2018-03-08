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
    public class ScraspRolesController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: ScraspRoles
        public ActionResult Index()
        {
            return View(db.ScraspRoles.ToList());
        }

        // GET: ScraspRoles/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ScraspRole scraspRole = db.ScraspRoles.Find(id);
            if (scraspRole == null)
            {
                return HttpNotFound();
            }
            return View(scraspRole);
        }

        // GET: ScraspRoles/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: ScraspRoles/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,roleName")] ScraspRole scraspRole)
        {
            if (ModelState.IsValid)
            {
                db.ScraspRoles.Add(scraspRole);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(scraspRole);
        }

        // GET: ScraspRoles/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ScraspRole scraspRole = db.ScraspRoles.Find(id);
            if (scraspRole == null)
            {
                return HttpNotFound();
            }
            return View(scraspRole);
        }

        // POST: ScraspRoles/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,roleName")] ScraspRole scraspRole)
        {
            if (ModelState.IsValid)
            {
                db.Entry(scraspRole).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(scraspRole);
        }

        // GET: ScraspRoles/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ScraspRole scraspRole = db.ScraspRoles.Find(id);
            if (scraspRole == null)
            {
                return HttpNotFound();
            }
            return View(scraspRole);
        }

        // POST: ScraspRoles/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            ScraspRole scraspRole = db.ScraspRoles.Find(id);
            db.ScraspRoles.Remove(scraspRole);
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
