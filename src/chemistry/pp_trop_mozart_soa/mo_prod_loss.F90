



      module mo_prod_loss

      use shr_kind_mod, only : r8 => shr_kind_r8

      private
      public :: exp_prod_loss
      public :: imp_prod_loss

      contains

      subroutine exp_prod_loss( prod, loss, y, rxt, het_rates )

      use ppgrid, only : pver

      implicit none

!--------------------------------------------------------------------
! ... dummy args
!--------------------------------------------------------------------
      real(r8), dimension(:,:,:), intent(out) :: &
            prod, &
            loss
      real(r8), intent(in) :: y(:,:,:)
      real(r8), intent(in) :: rxt(:,:,:)
      real(r8), intent(in) :: het_rates(:,:,:)



!--------------------------------------------------------------------
! ... loss and production for Explicit method
!--------------------------------------------------------------------


         loss(:,:,1) = ((rxt(:,:,54) +rxt(:,:,55) +rxt(:,:,56))* y(:,:,3) +rxt(:,:,94) &
                 * y(:,:,12) + het_rates(:,:,16))* y(:,:,16)
         prod(:,:,1) = 0._r8
         loss(:,:,2) = ((rxt(:,:,52) +rxt(:,:,53))* y(:,:,3) + rxt(:,:,4) &
                  + het_rates(:,:,4))* y(:,:,4)
         prod(:,:,2) = 0._r8
         loss(:,:,3) = ( + rxt(:,:,228) + het_rates(:,:,114))* y(:,:,114)
         prod(:,:,3) = 0._r8
         loss(:,:,4) = ( + het_rates(:,:,115))* y(:,:,115)
         prod(:,:,4) =rxt(:,:,228)*y(:,:,114)

      end subroutine exp_prod_loss

      subroutine imp_prod_loss( prod, loss, y, rxt, het_rates )

      use ppgrid, only : pver

      implicit none

!--------------------------------------------------------------------
! ... dummy args
!--------------------------------------------------------------------
      real(r8), dimension(:), intent(out) :: &
            prod, &
            loss
      real(r8), intent(in) :: y(:)
      real(r8), intent(in) :: rxt(:)
      real(r8), intent(in) :: het_rates(:)



!--------------------------------------------------------------------
! ... loss and production for Implicit method
!--------------------------------------------------------------------


         loss(118) = (rxt(46)* y(2) +rxt(49)* y(3) +rxt(79)* y(5) +rxt(82)* y(6) &
                  +rxt(64)* y(12) +rxt(72)* y(13) +rxt(59)* y(15) +rxt(118)* y(23) &
                  +rxt(139)* y(35) +rxt(185)* y(52) +rxt(161)* y(55) +rxt(167)* y(56) &
                  +rxt(223)* y(65) + rxt(2) + rxt(3) + het_rates(1))* y(1)
         prod(118) = (.200_r8*rxt(161)*y(55) +.200_r8*rxt(167)*y(56) + &
                 .100_r8*rxt(185)*y(52))*y(1) + (.250_r8*rxt(129)*y(33) + &
                 .250_r8*rxt(177)*y(59))*y(13) +rxt(45)*y(2)
         loss(112) = (rxt(46)* y(1) +rxt(77)* y(5) + (rxt(80) +rxt(81))* y(6) +rxt(88) &
                 * y(7) +rxt(70)* y(11) +rxt(63)* y(12) +rxt(71)* y(13) +rxt(74) &
                 * y(14) +rxt(99)* y(20) + rxt(45) + het_rates(2))* y(2)
         prod(112) = (rxt(47) +rxt(48))*y(3) +rxt(3)*y(1) +rxt(5)*y(6) +rxt(9)*y(7) &
                  +rxt(7)*y(10) +rxt(66)*y(12)*y(12) +rxt(62)*y(15)*y(13)
         loss(103) = (rxt(49)* y(1) + (rxt(52) +rxt(53))* y(4) +rxt(51)* y(11) &
                  + (rxt(54) +rxt(55) +rxt(56))* y(16) +rxt(57)* y(116) + rxt(47) &
                  + rxt(48) + rxt(50) + het_rates(3))* y(3)
         prod(103) =rxt(2)*y(1)
         loss(117) = ((rxt(95) +rxt(96))* y(12) + het_rates(17))* y(17)
         prod(117) = (.500_r8*rxt(118)*y(23) +.560_r8*rxt(139)*y(35) + &
                 .050_r8*rxt(161)*y(55) +.200_r8*rxt(167)*y(56) + &
                 .300_r8*rxt(185)*y(52))*y(1) + (rxt(14) +rxt(15) +rxt(97)*y(7) + &
                 rxt(98)*y(12) +rxt(99)*y(2))*y(20) + (.220_r8*rxt(168)*y(5) + &
                 .220_r8*rxt(170)*y(7) +.110_r8*rxt(172)*y(18) + &
                 .220_r8*rxt(173)*y(33))*y(57) + (.500_r8*rxt(203)*y(5) + &
                 .500_r8*rxt(204)*y(7) +.200_r8*rxt(206)*y(18) + &
                 .500_r8*rxt(207)*y(33))*y(63) + (.350_r8*rxt(111)*y(118) + &
                 rxt(134)*y(80) +rxt(155)*y(62))*y(12) + (rxt(30) +rxt(156)*y(7)) &
                 *y(62) +rxt(35)*y(27) +rxt(17)*y(32) +.700_r8*rxt(24)*y(55) &
                  +1.340_r8*rxt(23)*y(56) +.450_r8*rxt(37)*y(79) +2.000_r8*rxt(38) &
                 *y(80) +rxt(32)*y(85)
         loss(87) = (rxt(70)* y(2) +rxt(51)* y(3) +rxt(68)* y(12) + het_rates(11)) &
                 * y(11)
         prod(87) =rxt(56)*y(16)*y(3) +rxt(61)*y(15)*y(13) +rxt(15)*y(20)
         loss(52) = (rxt(57)* y(3) +rxt(75)* y(12) + het_rates(116))* y(116)
         prod(52) = 0._r8
         loss(43) = (rxt(76)* y(12) + het_rates(117))* y(117)
         prod(43) = 0._r8
         loss(100) = (rxt(59)* y(1) + (rxt(60) +rxt(61) +rxt(62))* y(13) + rxt(58) &
                  + het_rates(15))* y(15)
         prod(100) = (rxt(63)*y(2) +rxt(68)*y(11) +rxt(95)*y(17) +rxt(98)*y(20))*y(12) &
                  + (rxt(55)*y(16) +rxt(51)*y(11))*y(3) +rxt(70)*y(11)*y(2) +rxt(13) &
                 *y(19)
         loss(125) = (rxt(79)* y(1) +rxt(77)* y(2) +rxt(87)* y(7) +rxt(78)* y(13) &
                  +rxt(101)* y(18) +rxt(114)* y(25) +rxt(120)* y(30) +rxt(127)* y(33) &
                  +rxt(141)* y(37) +rxt(146)* y(39) +rxt(150)* y(42) +rxt(159)* y(45) &
                  +rxt(163)* y(47) +rxt(200)* y(50) +rxt(187)* y(53) + (rxt(168) + &
                 rxt(169))* y(57) +rxt(175)* y(59) +rxt(203)* y(63) +rxt(225)* y(66) &
                  +rxt(211)* y(70) +rxt(218)* y(73) +rxt(221)* y(76) +rxt(193)* y(84) &
                  +rxt(109)* y(120) + het_rates(5))* y(5)
         prod(125) = (rxt(5) +.500_r8*rxt(231) +rxt(80)*y(2))*y(6) &
                  +2.000_r8*rxt(52)*y(4)*y(3) +rxt(10)*y(7) +rxt(7)*y(10)
         loss(119) = (rxt(82)* y(1) + (rxt(80) +rxt(81))* y(2) +rxt(83)* y(7) +rxt(85) &
                 * y(12) +rxt(91)* y(13) +rxt(128)* y(33) +rxt(181)* y(59) +rxt(215) &
                 * y(78) + rxt(5) + rxt(231) + het_rates(6))* y(6)
         prod(119) = (rxt(77)*y(2) +rxt(78)*y(13) +rxt(79)*y(1) + &
                 2.000_r8*rxt(87)*y(7) +rxt(101)*y(18) +rxt(109)*y(120) + &
                 rxt(114)*y(25) +rxt(120)*y(30) +rxt(127)*y(33) +rxt(141)*y(37) + &
                 rxt(146)*y(39) +rxt(150)*y(42) +rxt(159)*y(45) +rxt(163)*y(47) + &
                 rxt(168)*y(57) +rxt(175)*y(59) +.920_r8*rxt(187)*y(53) + &
                 1.206_r8*rxt(193)*y(84) +.900_r8*rxt(200)*y(50) +rxt(203)*y(63) + &
                 .900_r8*rxt(211)*y(70) +.900_r8*rxt(218)*y(73) + &
                 .900_r8*rxt(221)*y(76) +rxt(225)*y(66))*y(5) + (rxt(9) + &
                 rxt(88)*y(2) +rxt(89)*y(12) +rxt(90)*y(13) +rxt(170)*y(57) + &
                 rxt(176)*y(59) +rxt(188)*y(53) +1.206_r8*rxt(194)*y(84) + &
                 rxt(198)*y(85) +rxt(204)*y(63) +rxt(224)*y(65))*y(7) + (rxt(12) + &
                 rxt(93) +rxt(92)*y(12))*y(9) + (rxt(6) +rxt(84))*y(10) &
                  + (rxt(157)*y(82) +.400_r8*rxt(197)*y(85))*y(12) &
                  + (.600_r8*rxt(20) +rxt(136))*y(81) + (rxt(21) +rxt(182))*y(83) &
                  +.700_r8*rxt(215)*y(78)*y(6) +rxt(8)*y(8) +.206_r8*rxt(195)*y(84) &
                 *y(13) +rxt(32)*y(85)
         loss(126) = (rxt(88)* y(2) +rxt(87)* y(5) +rxt(83)* y(6) +rxt(89)* y(12) &
                  +rxt(90)* y(13) +rxt(97)* y(20) +rxt(126)* y(32) +rxt(140)* y(35) &
                  +rxt(186)* y(52) +rxt(188)* y(53) +rxt(170)* y(57) +rxt(176)* y(59) &
                  +rxt(156)* y(62) +rxt(204)* y(63) +rxt(224)* y(65) +rxt(194)* y(84) &
                  +rxt(198)* y(85) +rxt(236)* y(101) + rxt(9) + rxt(10) + rxt(230) &
                  + het_rates(7))* y(7)
         prod(126) = (rxt(6) +rxt(7) +rxt(84))*y(10) + (rxt(86)*y(8) +rxt(137)*y(81) + &
                 .500_r8*rxt(183)*y(83))*y(12) + (rxt(81)*y(2) +rxt(82)*y(1))*y(6) &
                  +rxt(11)*y(9) +.400_r8*rxt(20)*y(81)
         loss(80) = (rxt(86)* y(12) + rxt(8) + het_rates(8))* y(8)
         prod(80) = (rxt(230) +rxt(97)*y(20) +rxt(126)*y(32) +rxt(156)*y(62) + &
                 rxt(236)*y(101))*y(7) + (.500_r8*rxt(231) +rxt(85)*y(12))*y(6) &
                  +2.000_r8*rxt(229)*y(10)
         loss(62) = (rxt(92)* y(12) + rxt(11) + rxt(12) + rxt(93) + het_rates(9)) &
                 * y(9)
         prod(62) =rxt(91)*y(13)*y(6)
         loss(58) = ( + rxt(6) + rxt(7) + rxt(84) + rxt(229) + het_rates(10))* y(10)
         prod(58) =rxt(83)*y(7)*y(6)
         loss(120) = (rxt(64)* y(1) +rxt(63)* y(2) +rxt(85)* y(6) +rxt(89)* y(7) &
                  +rxt(86)* y(8) +rxt(92)* y(9) +rxt(68)* y(11) + 2._r8*(rxt(66) + &
                 rxt(67))* y(12) +rxt(65)* y(13) +rxt(69)* y(14) +rxt(94)* y(16) &
                  + (rxt(95) +rxt(96))* y(17) +rxt(106)* y(19) +rxt(98)* y(20) &
                  +rxt(105)* y(21) +rxt(135)* y(22) +rxt(113)* y(23) +rxt(119)* y(26) &
                  +rxt(133)* y(27) +rxt(112)* y(29) +rxt(124)* y(31) +rxt(125)* y(32) &
                  +rxt(132)* y(34) +rxt(138)* y(35) +rxt(145)* y(36) +rxt(144)* y(38) &
                  +rxt(148)* y(40) +rxt(149)* y(41) +rxt(153)* y(43) +rxt(158)* y(44) &
                  +rxt(162)* y(46) +rxt(165)* y(48) +rxt(196)* y(49) +rxt(202)* y(51) &
                  +rxt(184)* y(52) +rxt(190)* y(54) +rxt(160)* y(55) +rxt(166)* y(56) &
                  +rxt(174)* y(58) +rxt(199)* y(60) +rxt(154)* y(61) +rxt(155)* y(62) &
                  +rxt(208)* y(64) +rxt(222)* y(65) +rxt(227)* y(67) +rxt(210)* y(68) &
                  +rxt(214)* y(69) +rxt(213)* y(71) +rxt(216)* y(72) +rxt(219)* y(75) &
                  +rxt(134)* y(80) +rxt(137)* y(81) +rxt(157)* y(82) +rxt(183)* y(83) &
                  +rxt(197)* y(85) +rxt(233)* y(100) + (rxt(234) +rxt(235))* y(101) &
                  +rxt(237)* y(103) +rxt(75)* y(116) +rxt(76)* y(117) +rxt(111) &
                 * y(118) +rxt(107)* y(119) + het_rates(12))* y(12)
         prod(120) = (rxt(59)*y(15) +rxt(72)*y(13) +.120_r8*rxt(118)*y(23) + &
                 .330_r8*rxt(139)*y(35) +.080_r8*rxt(161)*y(55) + &
                 .215_r8*rxt(167)*y(56) +.270_r8*rxt(185)*y(52) + &
                 .700_r8*rxt(223)*y(65))*y(1) + (.300_r8*rxt(106)*y(19) + &
                 .650_r8*rxt(111)*y(118) +.500_r8*rxt(124)*y(31) + &
                 .500_r8*rxt(148)*y(40) +.100_r8*rxt(174)*y(58))*y(12) &
                  + (rxt(70)*y(11) +rxt(71)*y(13) +rxt(74)*y(14) +rxt(99)*y(20))*y(2) &
                  + (2.000_r8*rxt(50) +rxt(54)*y(16) +rxt(51)*y(11) +rxt(57)*y(116)) &
                 *y(3) + (2.000_r8*rxt(60)*y(15) +rxt(78)*y(5) +rxt(90)*y(7))*y(13) &
                  +.500_r8*rxt(231)*y(6) +rxt(8)*y(8) +rxt(11)*y(9) +2.000_r8*rxt(16) &
                 *y(14) +rxt(13)*y(19) +rxt(26)*y(28) +rxt(25)*y(31) +rxt(19)*y(34) &
                  +rxt(27)*y(38) +rxt(18)*y(40) +rxt(28)*y(43) +rxt(40)*y(48) +rxt(39) &
                 *y(51) +rxt(31)*y(64) +rxt(42)*y(67) +rxt(41)*y(71)
         loss(124) = (rxt(72)* y(1) +rxt(71)* y(2) +rxt(78)* y(5) +rxt(91)* y(6) &
                  +rxt(90)* y(7) +rxt(65)* y(12) + 2._r8*rxt(73)* y(13) + (rxt(60) + &
                 rxt(61) +rxt(62))* y(15) +rxt(102)* y(18) +rxt(100)* y(20) +rxt(115) &
                 * y(25) +rxt(121)* y(30) +rxt(129)* y(33) +rxt(142)* y(37) +rxt(147) &
                 * y(39) +rxt(151)* y(42) +rxt(164)* y(47) +rxt(201)* y(50) +rxt(189) &
                 * y(53) +rxt(171)* y(57) +rxt(177)* y(59) +rxt(205)* y(63) +rxt(226) &
                 * y(66) +rxt(212)* y(70) +rxt(217)* y(73) +rxt(220)* y(76) +rxt(195) &
                 * y(84) +rxt(110)* y(120) + rxt(239) + het_rates(13))* y(13)
         prod(124) = (rxt(64)*y(1) +rxt(69)*y(14) +rxt(75)*y(116) +rxt(76)*y(117) + &
                 rxt(89)*y(7) +rxt(96)*y(17) +rxt(105)*y(21) +rxt(107)*y(119) + &
                 .350_r8*rxt(111)*y(118) +rxt(133)*y(27) +rxt(134)*y(80) + &
                 rxt(135)*y(22) +rxt(154)*y(61) +.200_r8*rxt(174)*y(58) + &
                 .500_r8*rxt(183)*y(83) +rxt(197)*y(85) +.250_r8*rxt(210)*y(68) + &
                 .500_r8*rxt(235)*y(101))*y(12) + (rxt(101)*y(18) +rxt(109)*y(120) + &
                 .250_r8*rxt(114)*y(25) +rxt(120)*y(30) +rxt(141)*y(37) + &
                 rxt(146)*y(39) +rxt(159)*y(45) +.470_r8*rxt(168)*y(57) + &
                 rxt(187)*y(53) +.794_r8*rxt(193)*y(84) +.900_r8*rxt(200)*y(50) + &
                 rxt(203)*y(63) +.900_r8*rxt(211)*y(70) +.900_r8*rxt(218)*y(73) + &
                 .900_r8*rxt(221)*y(76) +rxt(225)*y(66))*y(5) &
                  + (2.000_r8*rxt(103)*y(18) +rxt(122)*y(30) +.900_r8*rxt(130)*y(33) + &
                 rxt(143)*y(37) +.300_r8*rxt(152)*y(42) +.730_r8*rxt(172)*y(57) + &
                 rxt(178)*y(59) +rxt(191)*y(53) +.800_r8*rxt(206)*y(63))*y(18) &
                  + (.120_r8*rxt(118)*y(23) +.190_r8*rxt(139)*y(35) + &
                 .060_r8*rxt(161)*y(55) +.275_r8*rxt(167)*y(56) + &
                 .060_r8*rxt(185)*y(52) +rxt(223)*y(65))*y(1) + (rxt(97)*y(20) + &
                 .470_r8*rxt(170)*y(57) +rxt(188)*y(53) +.794_r8*rxt(194)*y(84) + &
                 rxt(198)*y(85) +rxt(204)*y(63))*y(7) + (.470_r8*rxt(173)*y(57) + &
                 rxt(192)*y(53) +rxt(207)*y(63))*y(33) + (rxt(74)*y(14) + &
                 rxt(99)*y(20))*y(2) + (rxt(12) +rxt(93))*y(9) + (rxt(116) +rxt(117)) &
                 *y(24) + (1.340_r8*rxt(22) +.660_r8*rxt(23))*y(56) +rxt(55)*y(16) &
                 *y(3) +.700_r8*rxt(215)*y(78)*y(6) +.794_r8*rxt(195)*y(84)*y(13) &
                  +rxt(58)*y(15) +2.000_r8*rxt(35)*y(27) +1.200_r8*rxt(123)*y(30) &
                 *y(30) +rxt(25)*y(31) +rxt(17)*y(32) +rxt(27)*y(38) +rxt(18)*y(40) &
                  +.900_r8*rxt(39)*y(51) +rxt(33)*y(54) +rxt(34)*y(61) +rxt(30)*y(62) &
                  +rxt(42)*y(67) +.560_r8*rxt(37)*y(79) +2.000_r8*rxt(38)*y(80) &
                  +rxt(32)*y(85) +rxt(108)*y(120)
         loss(55) = (rxt(74)* y(2) +rxt(69)* y(12) + rxt(16) + het_rates(14))* y(14)
         prod(55) = (.500_r8*rxt(239) +rxt(73)*y(13))*y(13) +rxt(67)*y(12)*y(12)
         loss(121) = (rxt(101)* y(5) +rxt(102)* y(13) + 2._r8*(rxt(103) +rxt(104)) &
                 * y(18) +rxt(122)* y(30) +rxt(130)* y(33) +rxt(143)* y(37) +rxt(152) &
                 * y(42) +rxt(191)* y(53) +rxt(172)* y(57) +rxt(178)* y(59) +rxt(206) &
                 * y(63) + het_rates(18))* y(18)
         prod(121) = (rxt(127)*y(5) +.900_r8*rxt(130)*y(18) +2.000_r8*rxt(131)*y(33) + &
                 rxt(173)*y(57) +rxt(179)*y(59) +rxt(192)*y(53) +rxt(207)*y(63))*y(33) &
                  + (rxt(94)*y(16) +.700_r8*rxt(106)*y(19) +rxt(119)*y(26))*y(12) &
                  +.310_r8*rxt(139)*y(35)*y(1) +rxt(54)*y(16)*y(3) +rxt(17)*y(32) &
                  +rxt(19)*y(34) +rxt(29)*y(41) +.300_r8*rxt(24)*y(55) &
                  +.400_r8*rxt(20)*y(81)
         loss(64) = (rxt(106)* y(12) + rxt(13) + het_rates(19))* y(19)
         prod(64) =rxt(102)*y(18)*y(13)
         loss(116) = (rxt(99)* y(2) +rxt(97)* y(7) +rxt(98)* y(12) +rxt(100)* y(13) &
                  + rxt(14) + rxt(15) + het_rates(20))* y(20)
         prod(116) = (rxt(101)*y(5) +2.000_r8*rxt(103)*y(18) +rxt(104)*y(18) + &
                 .700_r8*rxt(122)*y(30) +rxt(130)*y(33) +rxt(143)*y(37) + &
                 .800_r8*rxt(152)*y(42) +.880_r8*rxt(172)*y(57) + &
                 2.000_r8*rxt(178)*y(59) +1.200_r8*rxt(191)*y(53) + &
                 .700_r8*rxt(206)*y(63))*y(18) + (.500_r8*rxt(114)*y(25) + &
                 rxt(146)*y(39) +rxt(150)*y(42) +.500_r8*rxt(159)*y(45) + &
                 .250_r8*rxt(168)*y(57) +rxt(175)*y(59) +.510_r8*rxt(187)*y(53) + &
                 .072_r8*rxt(193)*y(84) +.100_r8*rxt(200)*y(50))*y(5) &
                  + (rxt(105)*y(21) +.300_r8*rxt(106)*y(19) +.500_r8*rxt(132)*y(34) + &
                 .800_r8*rxt(133)*y(27) +rxt(137)*y(81) +.500_r8*rxt(183)*y(83))*y(12) &
                  + (rxt(118)*y(23) +.540_r8*rxt(139)*y(35) +.800_r8*rxt(161)*y(55) + &
                 .700_r8*rxt(167)*y(56) +.600_r8*rxt(185)*y(52))*y(1) &
                  + (.250_r8*rxt(170)*y(57) +rxt(176)*y(59) +.600_r8*rxt(188)*y(53) + &
                 .072_r8*rxt(194)*y(84))*y(7) + (.250_r8*rxt(173)*y(57) + &
                 rxt(179)*y(59) +.600_r8*rxt(192)*y(53))*y(33) + (rxt(55)*y(16) + &
                 rxt(56)*y(16))*y(3) +.008_r8*rxt(195)*y(84)*y(13) +rxt(13)*y(19) &
                  +2.000_r8*rxt(117)*y(24) +rxt(35)*y(27) +rxt(18)*y(40) +rxt(28) &
                 *y(43) +.100_r8*rxt(39)*y(51) +.690_r8*rxt(33)*y(54) &
                  +1.340_r8*rxt(22)*y(56) +2.000_r8*rxt(180)*y(59)*y(59) +rxt(34) &
                 *y(61) +rxt(32)*y(85) +rxt(108)*y(120)
         loss(84) = (rxt(105)* y(12) + het_rates(21))* y(21)
         prod(84) = (rxt(104)*y(18) +.300_r8*rxt(122)*y(30) +.500_r8*rxt(152)*y(42) + &
                 .250_r8*rxt(172)*y(57) +.250_r8*rxt(191)*y(53) + &
                 .300_r8*rxt(206)*y(63))*y(18)
         loss(56) = (rxt(135)* y(12) + het_rates(22))* y(22)
         prod(56) = (.200_r8*rxt(122)*y(18) +.400_r8*rxt(123)*y(30))*y(30)
         loss(49) = ( + rxt(26) + het_rates(28))* y(28)
         prod(49) =rxt(115)*y(25)*y(13)
         loss(66) = (rxt(118)* y(1) +rxt(113)* y(12) + het_rates(23))* y(23)
         prod(66) = 0._r8
         loss(57) = ( + rxt(116) + rxt(117) + het_rates(24))* y(24)
         prod(57) =.750_r8*rxt(114)*y(25)*y(5) +rxt(26)*y(28)
         loss(89) = (rxt(114)* y(5) +rxt(115)* y(13) + het_rates(25))* y(25)
         prod(89) =rxt(113)*y(23)*y(12)
         loss(75) = (rxt(119)* y(12) + het_rates(26))* y(26)
         prod(75) = (.250_r8*rxt(139)*y(35) +.200_r8*rxt(185)*y(52))*y(1) &
                  + (.250_r8*rxt(129)*y(33) +.250_r8*rxt(177)*y(59))*y(13) &
                  +.100_r8*rxt(130)*y(33)*y(18)
         loss(97) = (rxt(133)* y(12) + rxt(35) + het_rates(27))* y(27)
         prod(97) = (.530_r8*rxt(168)*y(5) +.530_r8*rxt(170)*y(7) + &
                 .260_r8*rxt(172)*y(18) +.530_r8*rxt(173)*y(33))*y(57) &
                  + (.250_r8*rxt(203)*y(5) +.250_r8*rxt(204)*y(7) + &
                 .100_r8*rxt(206)*y(18) +.250_r8*rxt(207)*y(33))*y(63) +rxt(116)*y(24)
         loss(44) = (rxt(112)* y(12) + het_rates(29))* y(29)
         prod(44) = 0._r8
         loss(96) = (rxt(120)* y(5) +rxt(121)* y(13) +rxt(122)* y(18) + 2._r8*rxt(123) &
                 * y(30) + het_rates(30))* y(30)
         prod(96) = (rxt(112)*y(29) +.500_r8*rxt(124)*y(31))*y(12) +rxt(36)*y(46)
         loss(67) = (rxt(124)* y(12) + rxt(25) + het_rates(31))* y(31)
         prod(67) =rxt(121)*y(30)*y(13)
         loss(104) = (rxt(126)* y(7) +rxt(125)* y(12) + rxt(17) + het_rates(32)) &
                 * y(32)
         prod(104) = (rxt(120)*y(30) +.270_r8*rxt(141)*y(37) +rxt(146)*y(39) + &
                 rxt(159)*y(45) +rxt(163)*y(47) +.400_r8*rxt(200)*y(50))*y(5) &
                  + (.500_r8*rxt(139)*y(35) +.040_r8*rxt(161)*y(55))*y(1) &
                  + (.500_r8*rxt(124)*y(31) +rxt(135)*y(22))*y(12) &
                  + (.800_r8*rxt(122)*y(18) +1.600_r8*rxt(123)*y(30))*y(30) +rxt(25) &
                 *y(31) +rxt(18)*y(40) +rxt(40)*y(48) +.400_r8*rxt(39)*y(51)
         loss(122) = (rxt(127)* y(5) +rxt(128)* y(6) +rxt(129)* y(13) +rxt(130)* y(18) &
                  + 2._r8*rxt(131)* y(33) +rxt(192)* y(53) +rxt(173)* y(57) +rxt(207) &
                 * y(63) + het_rates(33))* y(33)
         prod(122) = (rxt(150)*y(42) +rxt(163)*y(47) +.530_r8*rxt(168)*y(57) + &
                 rxt(175)*y(59))*y(5) + (rxt(126)*y(32) +rxt(156)*y(62) + &
                 .530_r8*rxt(170)*y(57) +rxt(176)*y(59))*y(7) + (rxt(125)*y(32) + &
                 .500_r8*rxt(132)*y(34) +rxt(155)*y(62))*y(12) &
                  + (.300_r8*rxt(152)*y(42) +.260_r8*rxt(172)*y(57) +rxt(178)*y(59)) &
                 *y(18) + (.600_r8*rxt(20) +rxt(136))*y(81) +.530_r8*rxt(173)*y(57) &
                 *y(33) +rxt(29)*y(41) +rxt(28)*y(43) +rxt(36)*y(46) +rxt(40)*y(48) &
                  +.300_r8*rxt(24)*y(55) +1.340_r8*rxt(22)*y(56) &
                  +2.000_r8*rxt(180)*y(59)*y(59) +rxt(34)*y(61) +rxt(30)*y(62) &
                  +.130_r8*rxt(37)*y(79)
         loss(76) = (rxt(132)* y(12) + rxt(19) + het_rates(34))* y(34)
         prod(76) = (.750_r8*rxt(129)*y(33) +.750_r8*rxt(177)*y(59))*y(13)
         loss(102) = (rxt(139)* y(1) +rxt(140)* y(7) +rxt(138)* y(12) + het_rates(35)) &
                 * y(35)
         prod(102) =.070_r8*rxt(185)*y(52)*y(1) +.700_r8*rxt(24)*y(55)
         loss(45) = (rxt(145)* y(12) + het_rates(36))* y(36)
         prod(45) = 0._r8
         loss(98) = (rxt(141)* y(5) +rxt(142)* y(13) +rxt(143)* y(18) + het_rates(37)) &
                 * y(37)
         prod(98) = (rxt(144)*y(38) +rxt(145)*y(36))*y(12)
         loss(60) = (rxt(144)* y(12) + rxt(27) + het_rates(38))* y(38)
         prod(60) =rxt(142)*y(37)*y(13)
         loss(94) = (rxt(146)* y(5) +rxt(147)* y(13) + het_rates(39))* y(39)
         prod(94) = (rxt(138)*y(35) +.500_r8*rxt(148)*y(40))*y(12)
         loss(79) = (rxt(148)* y(12) + rxt(18) + het_rates(40))* y(40)
         prod(79) =rxt(147)*y(39)*y(13)
         loss(93) = (rxt(149)* y(12) + rxt(29) + het_rates(41))* y(41)
         prod(93) = (.820_r8*rxt(141)*y(37) +.500_r8*rxt(159)*y(45) + &
                 .250_r8*rxt(200)*y(50) +.100_r8*rxt(225)*y(66))*y(5) &
                  +.820_r8*rxt(143)*y(37)*y(18) +.820_r8*rxt(27)*y(38) &
                  +.250_r8*rxt(39)*y(51) +.100_r8*rxt(42)*y(67)
         loss(107) = (rxt(150)* y(5) +rxt(151)* y(13) +rxt(152)* y(18) &
                  + het_rates(42))* y(42)
         prod(107) = (rxt(149)*y(41) +rxt(153)*y(43))*y(12)
         loss(61) = (rxt(153)* y(12) + rxt(28) + het_rates(43))* y(43)
         prod(61) =rxt(151)*y(42)*y(13)
         loss(39) = (rxt(158)* y(12) + het_rates(44))* y(44)
         prod(39) = 0._r8
         loss(68) = (rxt(159)* y(5) + het_rates(45))* y(45)
         prod(68) =rxt(158)*y(44)*y(12)
         loss(40) = (rxt(196)* y(12) + het_rates(49))* y(49)
         prod(40) = 0._r8
         loss(95) = (rxt(200)* y(5) +rxt(201)* y(13) + het_rates(50))* y(50)
         prod(95) = (rxt(196)*y(49) +rxt(202)*y(51))*y(12)
         loss(91) = (rxt(202)* y(12) + rxt(39) + het_rates(51))* y(51)
         prod(91) =rxt(201)*y(50)*y(13)
         loss(74) = (rxt(162)* y(12) + rxt(36) + het_rates(46))* y(46)
         prod(74) =.800_r8*rxt(200)*y(50)*y(5) +.800_r8*rxt(39)*y(51)
         loss(92) = (rxt(163)* y(5) +rxt(164)* y(13) + het_rates(47))* y(47)
         prod(92) = (rxt(162)*y(46) +rxt(165)*y(48))*y(12)
         loss(59) = (rxt(165)* y(12) + rxt(40) + het_rates(48))* y(48)
         prod(59) =rxt(164)*y(47)*y(13)
         loss(99) = (rxt(185)* y(1) +rxt(186)* y(7) +rxt(184)* y(12) + het_rates(52)) &
                 * y(52)
         prod(99) = 0._r8
         loss(115) = (rxt(187)* y(5) +rxt(188)* y(7) +rxt(189)* y(13) +rxt(191)* y(18) &
                  +rxt(192)* y(33) + het_rates(53))* y(53)
         prod(115) = (rxt(184)*y(52) +.200_r8*rxt(190)*y(54))*y(12)
         loss(83) = (rxt(190)* y(12) + rxt(33) + het_rates(54))* y(54)
         prod(83) =rxt(189)*y(53)*y(13)
         loss(113) = (rxt(161)* y(1) +rxt(160)* y(12) + rxt(24) + het_rates(55)) &
                 * y(55)
         prod(113) = (.320_r8*rxt(187)*y(5) +.350_r8*rxt(188)*y(7) + &
                 .260_r8*rxt(191)*y(18) +.350_r8*rxt(192)*y(33))*y(53) &
                  + (.039_r8*rxt(193)*y(5) +.039_r8*rxt(194)*y(7) + &
                 .039_r8*rxt(195)*y(13))*y(84) + (.200_r8*rxt(185)*y(52) + &
                 rxt(223)*y(65))*y(1) +rxt(225)*y(66)*y(5) +.402_r8*rxt(33)*y(54) &
                  +rxt(42)*y(67)
         loss(109) = (rxt(167)* y(1) +rxt(166)* y(12) + rxt(22) + rxt(23) &
                  + het_rates(56))* y(56)
         prod(109) = (.230_r8*rxt(187)*y(5) +.250_r8*rxt(188)*y(7) + &
                 .190_r8*rxt(191)*y(18) +.250_r8*rxt(192)*y(33))*y(53) &
                  + (.167_r8*rxt(193)*y(5) +.167_r8*rxt(194)*y(7) + &
                 .167_r8*rxt(195)*y(13))*y(84) + (.400_r8*rxt(185)*y(52) + &
                 rxt(223)*y(65))*y(1) +rxt(225)*y(66)*y(5) +.288_r8*rxt(33)*y(54) &
                  +rxt(42)*y(67)
         loss(114) = ((rxt(168) +rxt(169))* y(5) +rxt(170)* y(7) +rxt(171)* y(13) &
                  +rxt(172)* y(18) +rxt(173)* y(33) + het_rates(57))* y(57)
         prod(114) = (rxt(160)*y(55) +.500_r8*rxt(166)*y(56) +.200_r8*rxt(174)*y(58)) &
                 *y(12)
         loss(63) = (rxt(174)* y(12) + het_rates(58))* y(58)
         prod(63) =rxt(171)*y(57)*y(13)
         loss(123) = (rxt(175)* y(5) +rxt(181)* y(6) +rxt(176)* y(7) +rxt(177)* y(13) &
                  +rxt(178)* y(18) +rxt(179)* y(33) + 2._r8*rxt(180)* y(59) &
                  + het_rates(59))* y(59)
         prod(123) = (.500_r8*rxt(166)*y(56) +.500_r8*rxt(174)*y(58))*y(12) &
                  + (rxt(21) +rxt(182))*y(83) +.200_r8*rxt(185)*y(52)*y(1) &
                  +.660_r8*rxt(22)*y(56)
         loss(69) = (rxt(199)* y(12) + het_rates(60))* y(60)
         prod(69) = (.370_r8*rxt(187)*y(5) +.400_r8*rxt(188)*y(7) + &
                 .300_r8*rxt(191)*y(18) +.400_r8*rxt(192)*y(33))*y(53) &
                  + (rxt(197)*y(12) +rxt(198)*y(7))*y(85)
         loss(108) = (rxt(154)* y(12) + rxt(34) + het_rates(61))* y(61)
         prod(108) = (.220_r8*rxt(168)*y(5) +.220_r8*rxt(170)*y(7) + &
                 .230_r8*rxt(172)*y(18) +.220_r8*rxt(173)*y(33))*y(57) &
                  + (.250_r8*rxt(203)*y(5) +.250_r8*rxt(204)*y(7) + &
                 .100_r8*rxt(206)*y(18) +.250_r8*rxt(207)*y(33))*y(63) &
                  + (.500_r8*rxt(148)*y(40) +.500_r8*rxt(183)*y(83))*y(12) &
                  +.200_r8*rxt(152)*y(42)*y(18)
         loss(110) = (rxt(156)* y(7) +rxt(155)* y(12) + rxt(30) + het_rates(62)) &
                 * y(62)
         prod(110) = (.250_r8*rxt(168)*y(57) +.250_r8*rxt(203)*y(63) + &
                 .450_r8*rxt(211)*y(70) +.540_r8*rxt(221)*y(76))*y(5) &
                  + (.500_r8*rxt(152)*y(42) +.240_r8*rxt(172)*y(57) + &
                 .100_r8*rxt(206)*y(63))*y(18) + (.950_r8*rxt(161)*y(55) + &
                 .800_r8*rxt(167)*y(56))*y(1) + (.250_r8*rxt(170)*y(57) + &
                 .250_r8*rxt(204)*y(63))*y(7) + (rxt(154)*y(61) +rxt(157)*y(82))*y(12) &
                  + (.250_r8*rxt(173)*y(57) +.250_r8*rxt(207)*y(63))*y(33) &
                  +.450_r8*rxt(41)*y(71) +.180_r8*rxt(37)*y(79)
         loss(111) = (rxt(203)* y(5) +rxt(204)* y(7) +rxt(205)* y(13) +rxt(206)* y(18) &
                  +rxt(207)* y(33) + het_rates(63))* y(63)
         prod(111) = (.800_r8*rxt(190)*y(54) +rxt(199)*y(60) +rxt(208)*y(64))*y(12)
         loss(53) = ((rxt(208) +rxt(209))* y(12) + rxt(31) + het_rates(64))* y(64)
         prod(53) = (rxt(195)*y(84) +rxt(205)*y(63))*y(13)
         loss(88) = (rxt(223)* y(1) +rxt(224)* y(7) +rxt(222)* y(12) + het_rates(65)) &
                 * y(65)
         prod(88) = 0._r8
         loss(101) = (rxt(225)* y(5) +rxt(226)* y(13) + het_rates(66))* y(66)
         prod(101) = (rxt(222)*y(65) +rxt(227)*y(67))*y(12) +rxt(224)*y(65)*y(7)
         loss(81) = (rxt(227)* y(12) + rxt(42) + het_rates(67))* y(67)
         prod(81) =rxt(226)*y(66)*y(13)
         loss(47) = (rxt(210)* y(12) + het_rates(68))* y(68)
         prod(47) = 0._r8
         loss(48) = (rxt(214)* y(12) + het_rates(69))* y(69)
         prod(48) =.250_r8*rxt(210)*y(68)*y(12)
         loss(85) = (rxt(211)* y(5) +rxt(212)* y(13) + het_rates(70))* y(70)
         prod(85) = (.700_r8*rxt(210)*y(68) +rxt(213)*y(71))*y(12)
         loss(70) = (rxt(213)* y(12) + rxt(41) + het_rates(71))* y(71)
         prod(70) =rxt(212)*y(70)*y(13)
         loss(51) = (rxt(215)* y(6) + het_rates(78))* y(78)
         prod(51) =rxt(214)*y(69)*y(12)
         loss(86) = ( + rxt(37) + het_rates(79))* y(79)
         prod(86) = (.900_r8*rxt(211)*y(70) +.900_r8*rxt(218)*y(73) + &
                 .620_r8*rxt(221)*y(76))*y(5) +.700_r8*rxt(215)*y(78)*y(6) &
                  +.900_r8*rxt(41)*y(71)
         loss(90) = (rxt(134)* y(12) + rxt(38) + het_rates(80))* y(80)
         prod(90) = (.250_r8*rxt(203)*y(63) +.450_r8*rxt(211)*y(70) + &
                 .900_r8*rxt(218)*y(73) +.340_r8*rxt(221)*y(76))*y(5) &
                  + (.250_r8*rxt(204)*y(7) +.100_r8*rxt(206)*y(18) + &
                 .250_r8*rxt(207)*y(33))*y(63) + (.650_r8*rxt(111)*y(118) + &
                 .200_r8*rxt(133)*y(27))*y(12) +.450_r8*rxt(41)*y(71) +.130_r8*rxt(37) &
                 *y(79)
         loss(41) = (rxt(216)* y(12) + het_rates(72))* y(72)
         prod(41) = 0._r8
         loss(71) = (rxt(218)* y(5) +rxt(217)* y(13) + het_rates(73))* y(73)
         prod(71) =rxt(216)*y(72)*y(12)
         loss(1) = ( + het_rates(74))* y(74)
         prod(1) =rxt(217)*y(73)*y(13)
         loss(42) = (rxt(219)* y(12) + het_rates(75))* y(75)
         prod(42) = 0._r8
         loss(77) = (rxt(221)* y(5) +rxt(220)* y(13) + het_rates(76))* y(76)
         prod(77) =rxt(219)*y(75)*y(12)
         loss(2) = ( + het_rates(77))* y(77)
         prod(2) =rxt(220)*y(76)*y(13)
         loss(78) = (rxt(137)* y(12) + rxt(20) + rxt(136) + het_rates(81))* y(81)
         prod(78) =rxt(128)*y(33)*y(6)
         loss(72) = (rxt(157)* y(12) + het_rates(82))* y(82)
         prod(72) =.100_r8*rxt(200)*y(50)*y(5) +rxt(140)*y(35)*y(7)
         loss(82) = (rxt(183)* y(12) + rxt(21) + rxt(182) + het_rates(83))* y(83)
         prod(82) =rxt(181)*y(59)*y(6)
         loss(106) = (rxt(193)* y(5) +rxt(194)* y(7) +rxt(195)* y(13) + het_rates(84)) &
                 * y(84)
         prod(106) =rxt(186)*y(52)*y(7)
         loss(105) = (rxt(198)* y(7) +rxt(197)* y(12) + rxt(32) + het_rates(85)) &
                 * y(85)
         prod(105) = (.800_r8*rxt(169)*y(57) +.080_r8*rxt(187)*y(53) + &
                 .794_r8*rxt(193)*y(84))*y(5) + (.794_r8*rxt(194)*y(7) + &
                 .794_r8*rxt(195)*y(13))*y(84)
         loss(46) = (rxt(233)* y(12) + het_rates(100))* y(100)
         prod(46) = (rxt(234)*y(12) +.500_r8*rxt(235)*y(12) +rxt(236)*y(7))*y(101)
         loss(54) = (rxt(236)* y(7) + (rxt(234) +rxt(235))* y(12) + het_rates(101)) &
                 * y(101)
         prod(54) = 0._r8
         loss(3) = ( + het_rates(102))* y(102)
         prod(3) =rxt(233)*y(100)*y(12)
         loss(38) = (rxt(237)* y(12) + het_rates(103))* y(103)
         prod(38) = 0._r8
         loss(4) = ( + het_rates(104))* y(104)
         prod(4) = 0._r8
         loss(5) = ( + het_rates(105))* y(105)
         prod(5) = 0._r8
         loss(6) = ( + het_rates(90))* y(90)
         prod(6) = 0._r8
         loss(7) = ( + het_rates(91))* y(91)
         prod(7) = 0._r8
         loss(8) = ( + het_rates(92))* y(92)
         prod(8) = 0._r8
         loss(9) = ( + het_rates(93))* y(93)
         prod(9) = 0._r8
         loss(10) = ( + het_rates(94))* y(94)
         prod(10) = 0._r8
         loss(11) = ( + het_rates(95))* y(95)
         prod(11) = 0._r8
         loss(12) = ( + het_rates(96))* y(96)
         prod(12) = 0._r8
         loss(13) = ( + het_rates(97))* y(97)
         prod(13) = 0._r8
         loss(14) = ( + het_rates(98))* y(98)
         prod(14) = 0._r8
         loss(15) = ( + het_rates(99))* y(99)
         prod(15) = 0._r8
         loss(16) = ( + rxt(232) + het_rates(86))* y(86)
         prod(16) = 0._r8
         loss(17) = ( + het_rates(87))* y(87)
         prod(17) =rxt(232)*y(86)
         loss(18) = ( + rxt(238) + het_rates(88))* y(88)
         prod(18) = 0._r8
         loss(19) = ( + het_rates(89))* y(89)
         prod(19) =rxt(238)*y(88)
         loss(50) = (rxt(111)* y(12) + het_rates(118))* y(118)
         prod(50) = 0._r8
         loss(65) = (rxt(107)* y(12) + het_rates(119))* y(119)
         prod(65) = (rxt(109)*y(5) +rxt(110)*y(13))*y(120) +.500_r8*rxt(118)*y(23) &
                 *y(1) +.350_r8*rxt(111)*y(118)*y(12)
         loss(73) = (rxt(109)* y(5) +rxt(110)* y(13) + rxt(108) + het_rates(120)) &
                 * y(120)
         prod(73) =rxt(100)*y(20)*y(13)
         loss(20) = ( + het_rates(106))* y(106)
         prod(20) = 0._r8
         loss(21) = ( + het_rates(107))* y(107)
         prod(21) = 0._r8
         loss(22) = ( + het_rates(108))* y(108)
         prod(22) = 0._r8
         loss(23) = ( + het_rates(109))* y(109)
         prod(23) = 0._r8
         loss(24) = ( + het_rates(110))* y(110)
         prod(24) = 0._r8
         loss(25) = ( + het_rates(111))* y(111)
         prod(25) = 0._r8
         loss(26) = ( + het_rates(112))* y(112)
         prod(26) = 0._r8
         loss(27) = ( + het_rates(113))* y(113)
         prod(27) = 0._r8
         loss(28) = ( + rxt(240) + het_rates(121))* y(121)
         prod(28) = 0._r8
         loss(29) = ( + rxt(241) + het_rates(122))* y(122)
         prod(29) = 0._r8
         loss(30) = ( + rxt(242) + het_rates(123))* y(123)
         prod(30) = 0._r8
         loss(31) = ( + het_rates(124))* y(124)
         prod(31) = 0._r8
         loss(32) = ( + rxt(243) + het_rates(125))* y(125)
         prod(32) = 0._r8
         loss(33) = ( + rxt(244) + het_rates(126))* y(126)
         prod(33) = 0._r8
         loss(34) = ( + rxt(245) + het_rates(127))* y(127)
         prod(34) = 0._r8
         loss(35) = ( + het_rates(128))* y(128)
         prod(35) = 0._r8
         loss(36) = ( + rxt(43) + het_rates(129))* y(129)
         prod(36) = 0._r8
         loss(37) = ( + rxt(44) + het_rates(130))* y(130)
         prod(37) = 0._r8

      end subroutine imp_prod_loss

      end module mo_prod_loss
