/// <summary>
/// Page FK API Mapping (ID 60050).
/// </summary>
page 60050 "FK API Mapping"
{

    Caption = 'API Mapping Lists';
    PageType = List;
    //ApplicationArea = all;
    UsageCategory = None;
    CardPageId = "FK API Mapping Card";
    SourceTable = "API Setup Header";
    RefreshOnActivate = true;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("Page Name"; Rec."Page Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Serivce Name"; Rec."Serivce Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }

            }
        }
    }
}
