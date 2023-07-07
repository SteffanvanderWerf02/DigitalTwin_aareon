namespace dt_aareon_emmen.Models
{
	//ViewModal of the errors screens
	public class ErrorViewModel
	{
		public string? RequestId { get; set; }

		public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
	}
}