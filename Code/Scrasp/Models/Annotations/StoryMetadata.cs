using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models
{
    public class StoryMetadata
    {
        [Display(Name ="Nom court")]
        public object shortName { get; set; }
        [Display(Name ="Personne en charge")]
        public object actor { get; set; }
        [Display(Name ="Description")]
        public object storyDescription { get; set; }
        [Display(Name = "Points")]
        public object points { get; set; }
    }
    [MetadataType(typeof(StoryMetadata))]
    public partial class Story { }
}