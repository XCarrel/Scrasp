
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------


namespace Scrasp.Models
{

using System;
    using System.Collections.Generic;
    
public partial class JobState
{

    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
    public JobState()
    {

        this.Jobs = new HashSet<Job>();

    }


    public int id { get; set; }

    public string stateName { get; set; }

    public Nullable<byte> allowClosure { get; set; }

    public Nullable<byte> hideInDashboard { get; set; }



    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]

    public virtual ICollection<Job> Jobs { get; set; }

}

}
