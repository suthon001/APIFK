/// <summary>
/// Page FK APi Log Card (ID 60054).
/// </summary>
page 60054 "FK APi Log Card"
{

    Caption = 'FK APi Log Card';
    PageType = Card;
    SourceTable = "API Log";
    UsageCategory = None;
    DataCaptionExpression = StrSubstNo('%1:%2', rec."Page Name", rec."Document No.");
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                    Caption = 'Table id';
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
                field("Last Error"; Rec."Last Error")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Error field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Date Time"; Rec."Date Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Time field.';
                }
            }
            group(JsonLog)
            {
                Caption = 'Json Log';
                field(ltJsonLog; ltJsonLog)
                {
                    Caption = 'Log';
                    MultiLine = true;
                    Editable = false;
                    ApplicationArea = all;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        ltJsonLog := rec.GetJsonLog();
    end;

    var
        ltJsonLog: Text;
}
