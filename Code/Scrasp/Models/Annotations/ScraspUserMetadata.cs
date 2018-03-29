using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace Scrasp.Models {
    public class ScraspUserMetadata {
        public object AspNetUsers_id { get; set; }

        [Display(Name = "Nom d'utilisateur")]
        public object username { get; set; }
    }

    [MetadataType(typeof(ScraspUserMetadata))]
    public partial class ScraspUser {
        public bool HasProject(int projectId) {
            return Teams.Any(team => team.Projects_id == projectId);
        }
    }
}