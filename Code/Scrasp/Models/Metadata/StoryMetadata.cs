using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class StoryMetadata {
        [Display(Name = "Story Identification")]
        public object id;
        [Display(Name = "Name")]
        public object shortName;
        [Display(Name = "Actor")]
        public object actor;
        [Display(Name = "Story Description")]
        public object storyDescription;
        [Display(Name = "Story Type Identification")]
        public object StoryTypes_id;
        [Display(Name = "Story State Identification")]
        public object StoryStates_id;
        [Display(Name = "Sprint Identification")]
        public object Sprints_id;
        [Display(Name = "Project Identification")]
        public object Projects_id;
        [Display(Name = "Points")]
        public object points;
    }

    [MetadataType(typeof(StoryMetadata))]
    public partial class Story {
    }
}