using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using Scrasp.Models;

namespace Scrasp.Controllers
{
    public class StoriesAPIController : ApiController
    {
        private scraspEntities db = new scraspEntities();

        // GET: api/StoriesAPI
        public IQueryable<Story> GetStories()
        {
            return db.Stories;
        }

        // GET: api/StoriesAPI/5
        [ResponseType(typeof(Story))]
        public IHttpActionResult GetStory(int id)
        {
            Story story = db.Stories.Find(id);
            if (story == null)
            {
                return NotFound();
            }

            return Ok(story);
        }

        // PUT: api/StoriesAPI/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutStory(int id, Story story)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != story.id)
            {
                return BadRequest();
            }

            db.Entry(story).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!StoryExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/StoriesAPI
        [ResponseType(typeof(Story))]
        public IHttpActionResult PostStory(Story story)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Stories.Add(story);
            db.SaveChanges();

            return CreatedAtRoute("DefaultApi", new { id = story.id }, story);
        }

        // DELETE: api/StoriesAPI/5
        [ResponseType(typeof(Story))]
        public IHttpActionResult DeleteStory(int id)
        {
            Story story = db.Stories.Find(id);
            if (story == null)
            {
                return NotFound();
            }

            db.Stories.Remove(story);
            db.SaveChanges();

            return Ok(story);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool StoryExists(int id)
        {
            return db.Stories.Count(e => e.id == id) > 0;
        }
    }
}