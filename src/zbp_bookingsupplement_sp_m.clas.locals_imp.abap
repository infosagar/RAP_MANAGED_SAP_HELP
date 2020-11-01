*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
PRIVATE SECTION.


METHODS get_features FOR FEATURES IMPORTING keys REQUEST requested_features FOR booksuppl RESULT result.

METHODS calculate_total_price FOR DETERMINATION booksuppl~calculateTotalSupplmPrice
      IMPORTING keys FOR booksuppl.
ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.



  METHOD get_features.

    READ ENTITIES OF Zi_travel_SP_m IN LOCAL MODE
      ENTITY booksuppl
         FIELDS ( booking_supplement_id )
           WITH VALUE #( FOR keyval IN keys ( %tky = keyval-%tky ) )
         RESULT  DATA(lt_booksupppl_result).


    result = VALUE #( FOR ls_travel IN lt_booksupppl_result
                       ( %tky                         = ls_travel-%tky
                         %field-booking_supplement_id = if_abap_behv=>fc-f-read_only
                        ) ).

  ENDMETHOD.

********************************************************************************
*
* Calculates total total flight price - including the price of supplements
*
********************************************************************************
  METHOD calculate_total_price.

    IF keys IS NOT INITIAL.
      zcl_travel_auxiliary_sp_m=>calculate_price(
          it_travel_id = VALUE #(  FOR GROUPS <booking_suppl> OF booksuppl_key IN keys
                                       GROUP BY booksuppl_key-travel_id WITHOUT MEMBERS
                                             ( <booking_suppl> ) ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
