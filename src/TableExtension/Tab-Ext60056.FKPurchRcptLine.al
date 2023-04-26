/// <summary>
/// TableExtension FK Purch. Rcpt. Line (ID 60056) extends Record Purch. Rcpt. Line.
/// </summary>
tableextension 60056 "FK Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
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
