using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class StoryStateMetadata {
        [Display(Name = "État")]
        public object stateName { get; set; }
    }

    [MetadataType(typeof(StoryStateMetadata))]
    public partial class StoryState { }
}