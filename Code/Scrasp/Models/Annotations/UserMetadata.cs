using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class ScraspUserMetadata {
        public object AspNetUsers_id { get; set; }

        [Display(Name = "Nom d'utilisateur")]
        public object username { get; set; }
    }

    [MetadataType(typeof(ScraspUserMetadata))]
    public partial class ScraspUser
    {
        public bool isInProject(Project project)
        {
            foreach (var team in this.Teams)
            {
                if (team.Projects_id == project.id)
                {
                    return true;
                }
            }

            return false;
        }


    }
}