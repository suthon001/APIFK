/// <summary>
/// Page FK API Mapping Card (ID 60051).
/// </summary>
page 60051 "FK API Mapping Card"
{
    Caption = 'API Mapping Card';
    PageType = Document;
    SourceTable = "API Setup Header";
    RefreshOnActivate = true;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            Group(General)
            {
                ShowCaption = false;
                field("Page Name"; Rec."Page Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
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
                field(URL; Rec.URL)
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field(documentNoFilter; documentNoFilter)
                {
                    ApplicationArea = all;
                    Caption = 'Document No. Filter';
                    ToolTip = 'Specifies value of the field.';
                }
            }
            part(LineHeader; "Export Template Subform")
            {
                Caption = 'Detail';
                ApplicationArea = all;
                SubPageLink = "Page Name" = field("Page Name");
                SubPageView = sorting("Page Name", "Line Type", "Field No.") where("Line Type" = const(header));
                ShowFilter = false;
            }
            part(Line; "Export Template Subform")
            {
                Caption = 'Ship-to Address';
                ApplicationArea = all;
                Visible = Rec."Table ID" = 18;
                SubPageLink = "Page Name" = field("Page Name");
                SubPageView = sorting("Page Name", "Line Type", "Field No.") where("Line Type" = const(line));
                ShowFilter = false;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            // action(TESTSENDAPI)
            // {
            //     Caption = 'TEST SEND';
            //     Image = GetEntries;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     ApplicationArea = Basic, Suite;
            //     Visible = false;
            //     trigger OnAction()
            //     var
            //         FKFunc: Codeunit "FK Func";
            //     begin
            //         FKFunc.purchaseorder(TESTSEND)
            //     end;
            // }
            action(GeneralDeteil)
            {
                Caption = 'Generate Detail';
                Image = GetEntries;

                ApplicationArea = Basic, Suite;
                ToolTip = 'Executes the Generate Detail action.';
                trigger OnAction()

                begin
                    rec.GenerateDetail();
                    CurrPage.Update();
                end;
            }
            action(ExportTemplateString)
            {
                Caption = 'Export Ex. Json String';
                Image = Export;

                ApplicationArea = Basic, Suite;
                ToolTip = 'Executes the Export Ex. Json String action.';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";

                begin
                    if rec.apisetuplineexists() then
                        Message('please generate detail befor export')
                    else
                        // if rec."Sub Table ID" = 0 then
                        FKFunc.ExportJsonFormat(rec."Page No.", rec."Table ID", rec."Serivce Name", rec."Page Name", documentNoFilter, false, false);
                    // else begin
                    // if rec."Page Name" = rec."Page Name"::"Purchase Order" then
                    //     DocumentType := DocumentType::Order;
                    // if rec."Page Name" = rec."Page Name"::"Purchase Return Order" then
                    //     DocumentType := DocumentType::"Return Order";
                    // if rec."Page Name" = rec."Page Name"::"Sales Invoice" then
                    //     DocumentType := DocumentType::Invoice;
                    // if rec."Page Name" = rec."Page Name"::"Sales Credit Memo" then
                    //     DocumentType := DocumentType::"Credit Memo";
                    // FKFunc.ExportJsonFormatMultitable(rec."Page No.", rec."Sub Page No.", DocumentType, rec."Serivce Name", rec."Page Name", rec."Table ID", rec."Sub Table ID", documentNoFilter, false);
                    //  end;
                end;
            }

            action(ExportTemplateStringShiptoAddress)
            {
                Caption = 'Export Ship-to Address';
                Visible = visableShiptoAddress;
                Image = Export;
                ApplicationArea = Basic, Suite;
                ToolTip = 'Executes the Export Ship-to Address action.';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    if rec.apisetuplineexists() then
                        Message('please generate detail befor export')
                    else begin
                        rec.TestField(rec."Sub Table ID");
                        FKFunc.ExportJsonFormat(rec."sub Page No.", rec."Sub Table ID", 'shiptolists', rec."Page Name", documentNoFilter, false, true);
                    end;
                end;
            }
            action(ShowLog)
            {
                Caption = 'Log Entries';
                ApplicationArea = Basic, Suite;
                Image = Log;

                ToolTip = 'Executes the Log Entries action.';
                trigger OnAction()
                var
                    FKLogEntry: Record "FK API Log";
                    FKAPILogEntries: Page "FK API Log Entry";
                begin
                    CLEAR(FKAPILogEntries);
                    FKLogEntry.reset();
                    FKLogEntry.SetRange("No.", rec."Table ID");
                    FKAPILogEntries.SetTableView(FKLogEntry);
                    FKAPILogEntries.RunModal();
                    CLEAR(FKAPILogEntries);
                end;
            }

            // action(ExportTimeOut)
            // {
            //     Caption = 'Export Time Out';
            //     Image = Export;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     ApplicationArea = basic;
            //     trigger OnAction()
            //     var
            //         FKFunc: Codeunit "FK Func";
            //         DocumentType: Enum "Sales Document Type";
            //     begin

            //         if rec."Page Name" = rec."Page Name"::"Purchase Order" then
            //             DocumentType := DocumentType::Order;
            //         if rec."Page Name" = rec."Page Name"::"Purchase Return Order" then
            //             DocumentType := DocumentType::"Return Order";
            //         if rec."Page Name" = rec."Page Name"::"Sales Invoice" then
            //             DocumentType := DocumentType::Invoice;
            //         if rec."Page Name" = rec."Page Name"::"Sales Credit Memo" then
            //             DocumentType := DocumentType::"Credit Memo";


            //         FKFunc.ExportTestTimeOut(rec."Page No.", rec."Sub Page No.", DocumentType, rec."Serivce Name", rec."Page Name", rec."Table ID", rec."Sub Table ID", documentNoFilter, false);


            //     end;

            // }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(generateDetail_promote; GeneralDeteil) { }
                actionref(Export_promote; ExportTemplateString) { }
                actionref(ExportShiptoAddress_promote; ExportTemplateStringShiptoAddress) { }
                actionref(Showlog_promote; ShowLog) { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        visableShiptoAddress := rec."Page Name" = rec."Page Name"::Customer;
    end;

    var

        documentNoFilter: Text;
        visableShiptoAddress: Boolean;

}
