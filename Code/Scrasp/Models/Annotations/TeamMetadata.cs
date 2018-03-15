using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class TeamMetadata { }

    [MetadataType(typeof(TeamMetadata))]
    public partial class Team { }
}