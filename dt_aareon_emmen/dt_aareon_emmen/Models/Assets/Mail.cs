using NuGet.Configuration;
using System.Net.Mail;

// https://stackoverflow.com/questions/55566016/how-to-send-email-using-two-factor-authentication-enabled-office365-email-accoun

namespace dt_aareon_emmen.Models.Assets
{
    public class Mail
    {
        private SmtpClient smtpClient;
        private IConfiguration _configuration;
        private ILogger _logger;

        /** Mail()
         * 
         * Create all items needed for sending mail
         * 
         */
        public Mail(IConfiguration _configuration, ILogger _logger)
        {
            this._configuration = _configuration;
            this._logger = _logger;
            this.smtpClient = new SmtpClient(this._configuration.GetValue<string>("Mail:Smtp:Server"));
            this.smtpClient.Port = this._configuration.GetValue<int>("Mail:Smtp:Client:Port");
            this.smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
            this.smtpClient.UseDefaultCredentials = false;
            //this.smtpClient.EnableSsl = true;
            this.smtpClient.Credentials = new System.Net.NetworkCredential
                (
                this._configuration.GetValue<string>("Mail:Smtp:Credentials:FromEmail"), 
                this._configuration.GetValue<string>("Mail:Smtp:Credentials:FromPassword")
                );
        }

        /** sendMail():
         * 
         * Send an email. It should contain the email adress of the person it is going to, the email subject and the email body.
         * This may be in HTML for prettier formatting.
         * 
         */
        public Boolean SendMail(string toEmail, string eMailSubject, string eMailBody)
        {
            try
            {
                MailMessage message = new MailMessage(this._configuration.GetValue<string>("Mail:Smtp:Credentials:FromEmail"), toEmail);
                message.Subject = eMailSubject;
                message.Body = eMailBody;
                message.IsBodyHtml = true;
                this.smtpClient.Send(message);
            }
            catch (Exception e)
            {
                _logger.LogError($"Exception! sending mail to {toEmail} has failed! {e}");
                return false;
            }
            return true;
        }
    }
}
