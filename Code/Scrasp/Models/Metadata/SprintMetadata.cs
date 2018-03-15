using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class SprintMetadata {
        [Display(Name = "Sprint Identification")]
        public object id;
        [Display(Name = "Sprint Number")]
        public object number;
        [Display(Name = "Sprint Description")]
        public object sprintDescription;
        [Display(Name = "Start Date")]
        public object startDate;
        [Display(Name = "End Date")]
        public object endDate;
    }

    [MetadataType(typeof(SprintMetadata))]
    public partial class Sprint {
    }
}