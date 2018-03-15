using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class StoryTypeMetadata {
        [Display(Name = "Type de story")]
        public object typeName { get; set; }
    }

    [MetadataType(typeof(StoryTypeMetadata))]
    public partial class StoryType { }
}