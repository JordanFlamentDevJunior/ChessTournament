namespace Models.Category
{
    public class UpdateCategory
    {
        public byte IdCategory { get; set; }
        public string NameCategory { get; set; }
        public byte MinAge { get; set; }
        public byte MaxAge { get; set; }
    }
}