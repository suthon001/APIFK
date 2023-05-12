/// <summary>
/// Page FK APi Log Card (ID 60054).
/// </summary>
page 60054 "FK APi Log Card"
{

    Caption = 'FK APi Log Card';
    PageType = Card;
    SourceTable = "FK API Log";
    UsageCategory = None;
    InsertAllowed = false;
    DataCaptionExpression = StrSubstNo('%1:%2', rec."Page Name", rec."Document No.");
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Method Type"; Rec."Method Type")
                {
                    ToolTip = 'Specifies the value of the Method Type field.';
                    ApplicationArea = all;
                }
                field("Page Name"; Rec."Page Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Page Name field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Is Manual"; Rec."Is Manual")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Is Manual field.';
                }
                field("Interface By"; Rec."Interface By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface By field.';

                }
                field("Date Time"; Rec."Date Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Time field.';
                }
            }

            group(JsonLog)
            {
                Caption = 'Log';
                Visible = showlog;
                field(ltJsonLog; ltJsonLog)
                {
                    Caption = 'Json Log';
                    MultiLine = true;
                    Editable = false;
                    ApplicationArea = all;
                }

            }
            group(Response)
            {
                Caption = 'Response';
                field(ltResponse; ltResponse)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Error field.';
                    MultiLine = true;
                    Editable = false;
                    Caption = 'Response';
                }
            }
            group(LastErr)
            {
                Caption = 'Error Log';
                field("Last Error"; Rec."Last Error")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Error field.';
                    MultiLine = true;
                    Editable = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        ltJsonLog := rec.GetJsonLog();
        ltResponse := rec.GetResponse();
        showlog := false;
        if rec."No." in [Database::Customer, Database::Vendor, Database::Item] then
            showlog := true;
    end;



    var
        ltJsonLog, ltResponse : Text;
        showlog: Boolean;

}
