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
    
    public partial class Team
    {
        public int id { get; set; }
        public int Projects_id { get; set; }
        public int ScraspUsers_id { get; set; }
    
        public virtual Project Project { get; set; }
        public virtual ScraspUser ScraspUser { get; set; }
    }
}
