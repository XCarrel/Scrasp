using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class JobStateMetadata {
        [Display(Name = "État")]
        public object stateName { get; set; }
    }

    [MetadataType(typeof(JobStateMetadata))]
    public partial class JobState { }
}