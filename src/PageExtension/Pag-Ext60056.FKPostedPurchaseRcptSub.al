/// <summary>
/// PageExtension FK Posted Purchase Rcpt. Sub. (ID 60056) extends Record Posted Purchase Rcpt. Subform.
/// </summary>
pageextension 60056 "FK Posted Purchase Rcpt. Sub." extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Ref. GR No. Intranet"; Rec."Ref. GR No. Intranet")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
    }
}
