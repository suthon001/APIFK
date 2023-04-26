/// <summary>
/// TableExtension FK Purch. Rcpt. Header (ID 60055) extends Record Purch. Rcpt. Header.
/// </summary>
tableextension 60055 "FK Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(60050; "Ref. GR No. Intranet"; Code[20])
        {
            Caption = 'Ref. GR No. Intranet';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
